# draagon.com

## Overview

Company website for Draagon at https://draagon.com. Static site hosted on Cloudflare Pages with DNS on Cloudflare.

## Stack

- Pure HTML/CSS — no framework, no build step
- Hosted on Cloudflare Pages (auto-deploy from GitHub `main` branch)
- DNS: Cloudflare (nameservers assigned during setup)
- Domain registered at GoDaddy (nameservers pointed to Cloudflare)

## Project Structure

```
draagon.com/
├── index.html      # Main page
├── style.css       # Styles
├── favicon.svg     # Site icon
├── 404.html        # Custom 404 page
├── CLAUDE.md       # This file
├── README.md       # Project readme
└── .gitignore      # Git ignores
```

## Deployment

Every push to `main` triggers an automatic Cloudflare Pages deploy. No build command needed — Cloudflare serves the files directly.

## DNS

Managed in Cloudflare dashboard. The domain was migrated from GoDaddy DNS.

## Email

The `hello@draagon.com` address needs email routing configured in Cloudflare (similar to mealing.com setup).

## Future Plans

- Expand content beyond placeholder
- Add project detail pages
- Blog/updates section
- SEO optimization
