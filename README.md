# Get Rates

Website for https://get-rates.com.

Static, SEO-ready website in `site/` (plain HTML/CSS, no build step).

## Site

| File | Purpose |
|------|---------|
| `site/index.html`, `services/`, `about/`, `contact/` | Pages with unique titles, meta descriptions, canonical URLs, Open Graph/Twitter tags |
| `site/404.html` | Not-found page (`noindex`) |
| `site/robots.txt`, `site/sitemap.xml` | Crawl rules and sitemap |
| `site/llms.txt` | Site summary for AI assistants |
| `site/site.webmanifest`, `site/favicon.svg`, `site/images/` | Icons and social share image |

Preview locally: `python3 -m http.server -d site 8000`, then open http://localhost:8000.

## SEO tooling

[claude-seo](https://github.com/AgriciDaniel/claude-seo) v2.4.0 is installed as project skills in `.claude/skills/` (`/seo`, `/seo-audit`, `/seo-schema`, ...) with subagents in `.claude/agents/`.

- `.claude/hooks/seo-runtime.sh` (SessionStart) builds the Python runtime in `.claude/skills/seo/.venv` when it is missing.
- A PostToolUse hook validates JSON-LD in every edited file and blocks placeholder text.
- `.claude/install-claude-seo.sh <checkout>` reinstalls or upgrades from a claude-seo checkout.
