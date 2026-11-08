# PageSift on Railway

PageSift — a self-hosted web scraper, crawler and document parser for AI agents: URLs, PDFs (with OCR) and Office files to clean Markdown/JSON, behind a Firecrawl- and Jina-Reader-compatible API. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/sJk2PY)

This repository packages the official [PageSift](https://github.com/YOLOW92/pagesift) image (`ghcr.io/yolow92/pagesift:1.2.1`, AGPL-3.0; upstream also offers a commercial licence) for Railway. It is an independent community packaging, not affiliated with or endorsed by the PageSift project.

## What you get

- One service from `ghcr.io/onepush-dev/pagesift:1.2.1`: the upstream image unmodified (single Rust binary + bundled Lightpanda browser) plus a start script that fixes volume ownership, drops to the unprivileged `pagesift` user and listens dual-stack on `$PORT`.
- **API key auth**: `PAGESIFT_API_KEYS` is generated per deploy; every request needs `Authorization: Bearer <key>`.
- **Persistent data** on a Railway volume at `/data`: cache, crawl/batch jobs (resume after restarts) and quota records.

## Use it

```bash
KEY=<PAGESIFT_API_KEYS>   # from the service's Variables tab
URL=https://<your-domain>

# Firecrawl v2 API
curl -s $URL/v2/scrape -H "Authorization: Bearer $KEY" -H 'Content-Type: application/json' \
  -d '{"url":"https://example.com","formats":["markdown"]}'
# Jina Reader style
curl -s $URL/r/https://example.com -H "Authorization: Bearer $KEY"
# Parse an uploaded file
curl -s $URL/v2/parse -H "Authorization: Bearer $KEY" -F file=@report.pdf -F 'options={"formats":["markdown"]}'
```

Firecrawl SDKs work by changing the API URL (`FirecrawlApp(api_key=KEY, api_url=URL)`). Many agent tools (Dify, n8n, LangChain, Open WebUI) accept a Firecrawl endpoint.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `PAGESIFT_API_KEYS` | generated | Comma-separated API key(s) clients must send as Bearer tokens |
| `PAGESIFT_PUBLIC_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public base URL used in links the API returns (e.g. job status URLs) |
| `PAGESIFT_LLM_API_KEY` | – | Optional: enables `/v2/agent` and LLM extraction (add after deploy) |
| `PAGESIFT_SEARCH_API_KEY` | – | Optional: search provider key for `/v2/search` (add after deploy) |

## Notes

- Health: `GET /healthz`. Prometheus metrics: `GET /metrics`.
- The bundled Lightpanda browser renders JavaScript pages; for full Chrome, point `[browser] remote` at an external CDP browser via a config file (`PAGESIFT_CONFIG`).
- To upgrade, bump the base image tag/digest in the `Dockerfile`; GitHub Actions rebuilds `ghcr.io/onepush-dev/pagesift`.
