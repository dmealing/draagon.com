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
├── index.html      # Main page
├── style.css       # Styles
├── favicon.svg     # Site icon
├── 404.html        # Custom 404 page
├── deploy.sh       # Deploy to Cloudflare Pages
├── CLAUDE.md       # This file
├── README.md       # Project readme
└── .gitignore      # Git ignores
```

## Deployment

Run `./deploy.sh` to deploy to Cloudflare Pages. Credentials are in `~/.config/cloudflare/credentials`.

Preview URL: https://draagon-com.pages.dev

## Cloudflare Configuration

| Setting | Value |
|---------|-------|
| Zone ID | `670f5f9fa2153cce8bd47764a93020b7` |
| Account ID | `330cb0efc83f8b1597896a9e85399636` |
| Pages Project | `draagon-com` |
| SSL | Full |
| Always HTTPS | On |
| Minification | HTML, CSS, JS |

## DNS Records

- `CNAME @ → draagon-com.pages.dev` (proxied)
- `CNAME www → draagon-com.pages.dev` (proxied)
- `MX` — Cloudflare Email Routing (auto-managed)
- `TXT @ (SPF)` — `v=spf1 include:_spf.mx.cloudflare.net ~all`
- `TXT _dmarc` — `v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s`
- `TXT cf2024-1._domainkey` — DKIM (auto-managed)

## Email Routing

All email forwards to `doug@dougmealing.com`:
- `doug@draagon.com` → doug@dougmealing.com
- `hello@draagon.com` → doug@dougmealing.com
- Catch-all (*@draagon.com) → doug@dougmealing.com

## GitHub

- Repo: https://github.com/dmealing/draagon.com

## Future Plans

- Expand content beyond placeholder
- Add project detail pages
- Blog/updates section
- SEO optimization
- Set up GitHub Actions for auto-deploy on push
