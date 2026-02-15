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

Run `./deploy.sh` to deploy to Cloudflare Pages. Credentials are in `~/.config/cloudflare/credentials`.

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

Credentials stored at `~/.config/cloudflare/credentials`:
```
CF_EMAIL=doug@dougmealing.com
CF_KEY=<Global API Key>
CF_ZONE_DRAAGON=670f5f9fa2153cce8bd47764a93020b7
CF_ACCOUNT=330cb0efc83f8b1597896a9e85399636
```

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
