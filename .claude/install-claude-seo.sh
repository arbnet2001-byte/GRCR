#!/usr/bin/env bash
# Project-level install of Claude SEO (https://github.com/AgriciDaniel/claude-seo).
#
# Mirrors the upstream install.sh, but installs into this repository's .claude/
# directory instead of ~/.claude, so the skills travel with the repo.
#
# Usage: bash .claude/install-claude-seo.sh [path-to-claude-seo-checkout]
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
SRC="${1:-${PROJECT_DIR}/.claude/skills/claude-seo}"
SKILLS="${PROJECT_DIR}/.claude/skills"
SKILL_DIR="${SKILLS}/seo"
AGENT_DIR="${PROJECT_DIR}/.claude/agents"

[ -f "${SRC}/.claude-plugin/plugin.json" ] || { echo "Not a claude-seo checkout: ${SRC}" >&2; exit 1; }
mkdir -p "${SKILL_DIR}" "${AGENT_DIR}"

# Core skills and extension skills, each as .claude/skills/<name>/SKILL.md
for d in "${SRC}/skills"/*/ "${SRC}/extensions"/*/skills/*/; do
    [ -d "${d}" ] || continue
    mkdir -p "${SKILLS}/$(basename "${d}")"
    cp -r "${d}". "${SKILLS}/$(basename "${d}")/"
done

# Shared payload lives under the seo skill (same layout as upstream install.sh)
for sub in schema data scripts hooks; do
    [ -d "${SRC}/${sub}" ] && mkdir -p "${SKILL_DIR}/${sub}" && cp -r "${SRC}/${sub}/". "${SKILL_DIR}/${sub}/"
done
chmod +x "${SKILL_DIR}/scripts/claude-seo"
for ext in "${SRC}/extensions"/*/; do
    name="$(basename "${ext}")"
    for sub in references scripts; do
        [ -d "${ext}${sub}" ] && mkdir -p "${SKILL_DIR}/extensions/${name}/${sub}" \
            && cp -r "${ext}${sub}/". "${SKILL_DIR}/extensions/${name}/${sub}/"
    done
    [ -d "${ext}agents" ] && cp "${ext}agents/"*.md "${AGENT_DIR}/"
done
cp "${SRC}/agents/"*.md "${AGENT_DIR}/"
cp "${SRC}/requirements.txt" "${SKILL_DIR}/requirements.txt"
cp "${SRC}/.claude-plugin/plugin.json" "${SKILL_DIR}/runtime-plugin.json"

# There is no ${CLAUDE_PLUGIN_ROOT} outside a plugin install: point the launcher
# at this project, and reference docs at project-relative skill paths.
installed_docs() {
    for root in "${SRC}/skills"/*/ "${SRC}/extensions"/*/skills/*/; do
        [ -d "${root}" ] || continue
        (cd "${root}" && find . -type f -name '*.md') | sed "s#^\.#${SKILLS}/$(basename "${root}")#"
    done
    for root in "${SRC}/extensions"/*/references/; do
        [ -d "${root}" ] || continue
        (cd "${root}" && find . -type f -name '*.md') | sed "s#^\.#${SKILL_DIR}/extensions/$(basename "$(dirname "${root}")")/references#"
    done
    for doc in "${SRC}/agents"/*.md "${SRC}/extensions"/*/agents/*.md; do
        [ -f "${doc}" ] && echo "${AGENT_DIR}/$(basename "${doc}")"
    done
}
installed_docs | sort -u | while IFS= read -r doc; do
    [ -f "${doc}" ] || continue
    sed -i \
        -e 's#\${CLAUDE_PLUGIN_ROOT}/scripts/#${CLAUDE_PROJECT_DIR:-.}/.claude/skills/seo/scripts/#g' \
        -e 's#\${CLAUDE_PLUGIN_ROOT}/skills/#.claude/skills/#g' \
        "${doc}"
done

echo "Installed claude-seo $(sed -n 's/.*"version": "\(.*\)".*/\1/p' "${SKILL_DIR}/runtime-plugin.json") into ${PROJECT_DIR}/.claude"
