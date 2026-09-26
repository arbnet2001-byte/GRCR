#!/usr/bin/env bash
# SessionStart: make sure the claude-seo Python runtime exists. The venv is
# gitignored, so fresh checkouts (and each cloud session) build it once here.
set -uo pipefail

SEO="${CLAUDE_PROJECT_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)}/.claude/skills/seo"
LAUNCHER="${SEO}/scripts/claude-seo"
[ -x "${LAUNCHER}" ] || exit 0

if ! "${LAUNCHER}" doctor 2>/dev/null | grep -q 'Runtime: ready'; then
    # Cloud sessions ship Chromium in /opt/pw-browsers; reuse it instead of downloading.
    if [ -d /opt/pw-browsers ]; then
        "${LAUNCHER}" setup --skip-browser >&2 || exit 0
    else
        "${LAUNCHER}" setup >&2 || exit 0
    fi
fi

# Map the preinstalled Chromium to the revision the venv's Playwright expects.
if [ -d /opt/pw-browsers ] && ! "${LAUNCHER}" doctor 2>/dev/null | grep -q 'Chromium: ready'; then
    shell_src="$(ls -d /opt/pw-browsers/chromium_headless_shell-*/chrome-linux 2>/dev/null | tail -1)"
    full_src="$(ls -d /opt/pw-browsers/chromium-[0-9]*/chrome-linux 2>/dev/null | tail -1)"
    browsers_json="$(ls "${SEO}"/.venv/lib/python3*/site-packages/playwright/driver/package/browsers.json 2>/dev/null | head -1)"
    [ -n "${shell_src}" ] && [ -n "${full_src}" ] && [ -n "${browsers_json}" ] || exit 0
    rev="$(python3 -c 'import json,sys; print(next(b["revision"] for b in json.load(open(sys.argv[1]))["browsers"] if b["name"]=="chromium"))' "${browsers_json}")"
    pw="${SEO}/ms-playwright"
    rm -rf "${pw}"
    mkdir -p "${pw}/chromium_headless_shell-${rev}/chrome-headless-shell-linux64" "${pw}/chromium-${rev}"
    for f in "${shell_src}"/*; do ln -s "${f}" "${pw}/chromium_headless_shell-${rev}/chrome-headless-shell-linux64/"; done
    ln -s "${shell_src}/headless_shell" "${pw}/chromium_headless_shell-${rev}/chrome-headless-shell-linux64/chrome-headless-shell"
    ln -s "${full_src}" "${pw}/chromium-${rev}/chrome-linux64"
    touch "${pw}"/chromium{,_headless_shell}-"${rev}"/{INSTALLATION_COMPLETE,DEPENDENCIES_VALIDATED}
    python3 - "${SEO}/runtime-state.json" <<'EOF'
import json, sys
p = sys.argv[1]
s = json.load(open(p))
s["browser_ready"] = True
json.dump(s, open(p, "w"), indent=2)
EOF
fi
exit 0
