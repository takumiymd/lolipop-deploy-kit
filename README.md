# lolipop-deploy-kit

A small deployment kit for static websites hosted on Lolipop rental server.

This project installs a GitHub Actions workflow that deploys a static website to Lolipop by FTPS whenever changes are pushed to the `main` branch.

## Why

Lolipop rental server uses FTP/FTPS for website uploads. Manually uploading files with an FTP client every time is annoying, and slow.

With this kit, deployment becomes:

```bash
git push origin main
```

GitHub Actions handles the upload automatically.

## Features

- GitHub Actions workflow for Lolipop FTPS deployment
- Uses GitHub Repository Secrets for FTP credentials
- Excludes development files from upload
- Works with static HTML/CSS/JS websites
- Supports manual deployment from the GitHub Actions tab
- Simple install script for adding the workflow to other projects

## Project structure

```text
lolipop-deploy-kit/
├── README.md
├── install.sh
├── templates/
│   └── deploy.yml
├── scripts/
│   └── check-static-site.sh
└── docs/
    └── secrets.md
```

## Install

From inside a static website project, run:

```bash
../lolipop-deploy-kit/install.sh .
```

This creates:

```text
.github/workflows/deploy.yml
```

## GitHub Secrets

Add these as Repository Secrets:

```text
Repository → Settings → Secrets and variables → Actions → New repository secret
```

Required secrets:

| Secret name | Meaning |
|---|---|
| `FTP_SERVER` | Lolipop FTP server host |
| `FTP_USERNAME` | FTP login username |
| `FTP_PASSWORD` | FTP login password |
| `FTP_SERVER_DIR` | Remote upload directory |


Each Secret Name:

```text
Name: FTP_SERVER
Secret: users0000.lolipop.jp
```

See:

```text
docs/secrets.md
```

## deploy.yml

The installed workflow looks like this:

```yml
name: Deploy to Lolipop

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  deploy:
    name: Upload website by FTPS
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Deploy to Lolipop
        uses: SamKirkland/FTP-Deploy-Action@v4.4.0
        with:
          server: ${{ secrets.FTP_SERVER }}
          username: ${{ secrets.FTP_USERNAME }}
          password: ${{ secrets.FTP_PASSWORD }}
          protocol: ftps
          local-dir: ./
          server-dir: ${{ secrets.FTP_SERVER_DIR }}
          exclude: |
            **/.git*
            **/.git*/**
            **/node_modules/**
            .github/**
            README.md
            scripts/**
            docs/**
            **/.DS_Store
```

## Deployment flow

After editing your website:

```bash
git add .
git commit -m "Update website"
git push origin main
```

GitHub Actions will run automatically and upload the website files to Lolipop.

## Manual deployment

You can also deploy manually:

```text
GitHub → Actions → Deploy to Lolipop → Run workflow
```

## Check a static site

Run:

```bash
./scripts/check-static-site.sh /path/to/static-site
```

This checks for common static-site setup issues, such as missing `index.html` or unwanted `.DS_Store` files.

## Notes

This kit is intended for static websites.

Examples:

- HTML
- CSS
- JavaScript
- image assets

It does not build React, Astro, Next.js, Vite, or other frontend frameworks by default.

For build-based projects, add a build step before the FTPS deploy step.

## Common issues

### Login failed

Check these secrets:

```text
FTP_SERVER
FTP_USERNAME
FTP_PASSWORD
```

Make sure `FTP_SERVER` does not include `ftp://`, `ftps://`, or `https://`.

### Deployment succeeded but website did not update

Check:

```text
FTP_SERVER_DIR
```

The workflow may be uploading files to the wrong directory.

### Missing files online

Check the `exclude` section in `.github/workflows/deploy.yml`.

Do not exclude required website files like:

```text
index.html
assets/
catalog.html
```

