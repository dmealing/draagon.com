# draagon.com

## Overview

Company website for Draagon at https://draagon.com. Static site hosted on Cloudflare Pages with DNS on Cloudflare.

## Stack

- Pure HTML/CSS — no framework, no build step
- Hosted on Cloudflare Pages (direct upload via Wrangler)
- DNS: Cloudflare (nameservers: denver.ns.cloudflare.com, robin.ns.cloudflare.com)
- Domain registered at GoDaddy (nameservers pointed to Cloudflare)
- Email: Cloudflare Email Routing → doug@dougmealing.com

## Project Structure

```
draagon.com/
├── index.html              # Main page
├── style.css               # Styles
├── favicon.svg             # Browser tab icon (dragon head)
├── 404.html                # Custom 404 page
├── deploy.sh               # Deploy to Cloudflare Pages
├── images/
│   ├── logo.svg            # Dragon head logo (light, for dark bg)
│   ├── logo_head-480x365.png   # Dragon head PNG (small)
│   └── logo_head-960x730.png   # Dragon head PNG (large)
├── CLAUDE.md               # This file
├── README.md               # Project readme
└── .gitignore              # Git ignores
```

## Logo

The dragon head logo comes from the draagon-ai project (`~/Development/draagon-ai/images/`). The original uses navy blue (#1a417a) and medium blue (#0b72b9). For the dark-themed website:
- `images/logo.svg` — recolored to light purple (#8b9eff) and light blue (#6db3f8) for dark backgrounds
- `favicon.svg` — recolored to site accent (#6d5aff) and purple (#a855f7)

Original source files:
- `~/Development/draagon-ai/images/logo_head.jpg` — original JPG
- `~/Development/draagon-ai/images/logo_head-stroke-and-fill.svg` — SVG with white stroke outline
- `~/Development/draagon-ai/platform/web/src/assets/draagon-logo.svg` — clean SVG (navy/blue)

## Deployment

Run `./deploy.sh` to deploy to Cloudflare Pages. It fetches a scoped deploy token (`pages-deploy-draagon-com`, Account: Pages Write) from Infisical (project `deploy`, env `dev`) through `keys-axi run --only CLOUDFLARE_PAGES_TOKEN_DRAAGON_COM CLOUDFLARE_ACCOUNT_ID`, maps it to `CLOUDFLARE_API_TOKEN` for wrangler, and clears any global-key variables. wrangler is pinned in the script (`WRANGLER_VERSION`) and run through `npx`. Values are never printed.

```bash
./deploy.sh                    # Deploy current files
```

Preview URL: https://draagon-com.pages.dev
Production URL: https://draagon.com

## Cloudflare Configuration

| Setting | Value |
|---------|-------|
| Zone ID | `670f5f9fa2153cce8bd47764a93020b7` |
| Account ID | `330cb0efc83f8b1597896a9e85399636` |
| Pages Project | `draagon-com` |
| SSL | Full |
| Always HTTPS | On |
| Minification | HTML, CSS, JS |

### Cloudflare API Access

Deploys use only the scoped token above. Do not use the account-wide global API key for deploys.

## DNS Records

| Type | Name | Value | Notes |
|------|------|-------|-------|
| CNAME | @ | draagon-com.pages.dev | Proxied |
| CNAME | www | draagon-com.pages.dev | Proxied |
| MX | @ | route{1,2,3}.mx.cloudflare.net | Auto-managed by Email Routing |
| TXT | @ | v=spf1 include:_spf.mx.cloudflare.net ~all | SPF |
| TXT | _dmarc | v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s | DMARC |
| TXT | cf2024-1._domainkey | (DKIM key) | Auto-managed |

## Email Routing

All email forwards to `doug@dougmealing.com`:
- `doug@draagon.com` → doug@dougmealing.com
- `hello@draagon.com` → doug@dougmealing.com
- Catch-all (*@draagon.com) → doug@dougmealing.com

## GitHub

- Repo: https://github.com/dmealing/draagon.com

## Nameserver Migration

**Status: Complete** (2026-02-15) — Nameservers updated at GoDaddy, zone active on Cloudflare.
- Old: `ns03.domaincontrol.com` / `ns04.domaincontrol.com` (GoDaddy)
- New: `denver.ns.cloudflare.com` / `robin.ns.cloudflare.com` (Cloudflare)
- Old GoDaddy DNS had: A record → 160.153.60.102, MX → mail.draagon.com

## SSL

Universal SSL certificate auto-provisioned by Cloudflare (free plan):
- **Primary**: Google Trust Services, covers `draagon.com` + `*.draagon.com`
- **Backup**: Let's Encrypt (standby)
- Auto-renews before expiry

## Future Plans

- Expand content beyond placeholder
- Add project detail pages
- Blog/updates section
- SEO optimization (OpenGraph tags, structured data)
- Set up GitHub Actions for auto-deploy on push

## Disk I/O: keep throwaway data off the drives

Test databases, sandboxes and temp files must not wear out the developer's drives.

- **Throwaway data goes in RAM.** Put scratch files, mutation-testing sandboxes (Stryker
  `tempDirName`) and test-only temp directories under `$DEV_SCRATCH` (fall back to the system temp
  directory when it is unset). Delete what you create when the run ends.
- **Test databases run on a capped tmpfs at the image's `VOLUME` path** (`postgres:18*`:
  `/var/lib/postgresql`; `postgres:16/17` and `pgvector:*-pg17`: `/var/lib/postgresql/data`;
  `mysql:8*`: `/var/lib/mysql`; check others with `docker image inspect -f '{{json .Config.Volumes}}'`),
  `size=2g`, with Postgres durability off: `-c fsync=off -c synchronous_commit=off -c full_page_writes=off`.
- **Every container you start, you remove.** Use `docker run --rm`, Testcontainers with Ryuk enabled,
  or explicit teardown in a `finally`/`trap`. Never leave a hand-started database running after your
  task. A database you mean to keep gets the label `dev.keep=true`.
- **Generators and tools never rewrite a file whose bytes did not change**, write any manifest once per
  run (not once per file), and verify drift in memory rather than by rendering everything to a temp
  directory.
- **Run the narrowest tests that prove the change** while iterating (one module, the affected test
  classes); run the full suite once, before the PR.
- **No background processes outlive the task.** Kill test watchers, dev servers and sandboxes you
  started before you finish.
