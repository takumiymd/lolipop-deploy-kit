# GitHub Secrets for Lolipop Deployment

This file explains the GitHub Repository Secrets required for deploying a static website to Lolipop rental server using GitHub Actions and FTPS.

## Where to add secrets

Go to your GitHub repository:

```text
Repository → Settings → Secrets and variables → Actions → New repository secret
```

Each Secret Name:

```text
Name: FTP_SERVER
Secret: users0000.lolipop.jp
```


## Required secrets

| Secret name | Meaning | Example |
|---|---|---|
| `FTP_SERVER` | Lolipop FTP server host | `users0000.lolipop.jp` |
| `FTP_USERNAME` | FTP login username | `your-ftp-username` |
| `FTP_PASSWORD` | FTP login password | `your-ftp-password` |
| `FTP_SERVER_DIR` | Remote upload directory | `/` |

## FTP_SERVER

Use only the FTP host name.

Good:

```text
users0000.lolipop.jp
```

Bad:

```text
ftp://users0000.lolipop.jp
ftps://users0000.lolipop.jp
https://users0000.lolipop.jp
```

## FTP_SERVER_DIR

This is the folder on Lolipop where the website files should be uploaded.

Common examples:

```text
/
```

```text
/web/
```

```text
/example.com/
```

Use the folder that contains the public `index.html` for the domain.

If the deployment succeeds but the website does not update, `FTP_SERVER_DIR` is probably pointing to the wrong folder.

## Workflow reference

The deployment workflow reads the secrets like this:

```yml
server: ${{ secrets.FTP_SERVER }}
username: ${{ secrets.FTP_USERNAME }}
password: ${{ secrets.FTP_PASSWORD }}
server-dir: ${{ secrets.FTP_SERVER_DIR }}
```

## Testing deployment

After adding the secrets, trigger deployment by pushing to `main`:

```bash
git add -A
git commit -m "Update website"
git push origin main
```

Or manually run it from GitHub:

```text
Repository → Actions → Deploy to Lolipop → Run workflow
```

## Troubleshooting

### Login failed

Check:

```text
FTP_SERVER
FTP_USERNAME
FTP_PASSWORD
```

Make sure the FTP server does not include `ftp://`, `ftps://`, or `https://`.

### Deployment succeeded but website did not change

Check:

```text
FTP_SERVER_DIR
```

The workflow may be uploading files to the wrong directory.

### Some files are missing online

Check the `exclude` section in `.github/workflows/deploy.yml`.

Example:

```yml
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

Only exclude development files. Do not exclude `assets/`, `index.html`, or catalog pages.

