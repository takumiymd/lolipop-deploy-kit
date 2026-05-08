# ロリポップ！デプロイキット (lolipop-deploy-kit)

A small deployment kit for static websites hosted on Lolipop! rental server.

ロリポップ！レンタルサーバーで公開している静的 ウェブサイトを、GitHub Actions から FTPS で自動デプロイするための小さなデプロイキットです。

This project installs a GitHub Actions workflow that deploys a static website to Lolipop by FTPS whenever changes are pushed to the `main` branch.

このプロジェクトを使うと、`main` ブランチに変更を push したタイミングで、GitHub Actions が自動的にロリポップ！サーバーへファイルをアップロードします。

## Why

ロリポップ！レンタルサーバーでは、ウェブサイトのアップロードに FTP / FTPS を使うことが一般的です。

Every time you update a website, manually uploading files with an FTP client is annoying, slow, and easy to forget.

ウェブサイトを更新するたびに FTP クライアントを開いて、手作業でファイルをアップロードするのは面倒です。  
このキットは、その手作業を GitHub Actions に任せられます。

With this kit, deployment becomes:

```bash
git push origin main
```

GitHub Actions handles the upload automatically.

つまり、普段通りGitHubにpushするだけで、サーバーへのアップロードまで自動化できます。

## Features

- GitHub Actions workflow for Lolipop FTPS deployment
- Uses GitHub Repository Secrets for FTP credentials
- Excludes development files from upload
- Works with static HTML/CSS/JS websites
- Supports manual deployment from the GitHub Actions tab
- Simple install script for adding the workflow to other projects

日本語(Japanese):

- ロリポップ！向けの FTPS デプロイ用 GitHub Actions ワークフロー
- FTP 情報を GitHub Repository Secrets で安全に管理
- `.git` や `node_modules` などの開発用ファイルをアップロード対象から除外
- HTML / CSS / JavaScript の静的サイトに対応
- GitHub Actions タブから手動デプロイも可能
- 他の静的サイトプロジェクトに簡単に追加できる install script 付き

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

日本語(Japanese):

静的サイトのプロジェクトフォルダ内で、以下のコマンドを実行します。

```bash
../lolipop-deploy-kit/install.sh .
```

すると、対象プロジェクトに以下の GitHub Actions ワークフローが作成されます。

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

日本語(Japanese):

GitHub の Repository Secrets に、ロリポップ！の FTP 情報を登録します。

```text
Repository → Settings → Secrets and variables → Actions → New repository secret
```

必要な Secrets:

| Secret name | 説明 |
|---|---|
| `FTP_SERVER` | ロリポップ！の FTP サーバー名 |
| `FTP_USERNAME` | FTP ログインユーザー名 |
| `FTP_PASSWORD` | FTP ログインパスワード |
| `FTP_SERVER_DIR` | アップロード先のサーバーディレクトリ |

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

日本語(Japanese):

この workflow は、`main` ブランチに push されたタイミングで自動的に実行されます。  
また、GitHub Actions 画面から手動実行することもできます。

## Deployment flow

After editing your website:

```bash
git add .
git commit -m "Update website"
git push origin main
```

GitHub Actions will run automatically and upload the website files to Lolipop.

日本語(Japanese):

ウェブサイトを編集した後は、通常通り Git に commit して push します。

```bash
git add .
git commit -m "Update website"
git push origin main
```

push が完了すると、GitHub Actions が自動的に実行され、ロリポップ！サーバーへファイルがアップロードされます。

## Manual deployment

You can also deploy manually:

```text
GitHub → Actions → Deploy to Lolipop → Run workflow
```

日本語(Japanese):

自動デプロイだけでなく、GitHub Actions の画面から手動でデプロイすることもできます。

```text
GitHub → Actions → Deploy to Lolipop → Run workflow
```

## Check a static site

Run:

```bash
./scripts/check-static-site.sh /path/to/static-site
```

This checks for common static-site setup issues, such as missing `index.html` or unwanted `.DS_Store` files.

日本語(Japanese):

静的サイトの基本的な構成チェックを行うこともできます。

```bash
./scripts/check-static-site.sh /path/to/static-site
```

このスクリプトは、以下のようなよくある問題を確認します。

- `index.html` が存在するか
- `.DS_Store` のような不要ファイルが含まれていないか
- 静的サイトとして最低限必要な構成になっているか

## Notes

This kit is intended for static websites.

Examples:

- HTML
- CSS
- JavaScript
- image assets

日本語(Japanese):

このキットは、静的 ウェブサイト向けです。

対象例:

- HTML
- CSS
- JavaScript
- 画像ファイル
- フォント
- 静的な assets フォルダ

It does not build React, Astro, Next.js, Vite, or other frontend frameworks by default.

For build-based projects, add a build step before the FTPS deploy step.

日本語(Japanese):

React、Astro、Next.js、Vite などの build が必要なプロジェクトには、そのままでは対応していません。  
その場合は、FTPS デプロイの前に build step を追加してください。

Example:

```yml
- name: Build
  run: npm ci && npm run build
```

Then set `local-dir` to the build output directory, such as:

```yml
local-dir: ./dist/
```

## Common issues

### Login failed

Check these secrets:

```text
FTP_SERVER
FTP_USERNAME
FTP_PASSWORD
```

Make sure `FTP_SERVER` does not include `ftp://`, `ftps://`, or `https://`.

日本語(Japanese):

ログインに失敗する場合は、以下の Secrets を確認してください。

```text
FTP_SERVER
FTP_USERNAME
FTP_PASSWORD
```

`FTP_SERVER` には、以下を付けないでください。

```text
ftp://
ftps://
https://
```

正しい例:

```text
users0000.lolipop.jp
```

### Deployment succeeded but website did not update

Check:

```text
FTP_SERVER_DIR
```

The workflow may be uploading files to the wrong directory.

日本語(Japanese):

GitHub Actions では成功しているのに ウェブサイトが更新されない場合は、アップロード先ディレクトリが間違っている可能性があります。

確認する Secret:

```text
FTP_SERVER_DIR
```

ロリポップ！側の公開フォルダに正しくアップロードされているか確認してください。

### Missing files online

Check the `exclude` section in `.github/workflows/deploy.yml`.

Do not exclude required website files like:

```text
index.html
assets/
catalog.html
```

日本語(Japanese):

アップロード後に一部のファイルが表示されない場合は、`.github/workflows/deploy.yml` の `exclude` 設定を確認してください。

必要なファイルやフォルダを除外しないように注意してください。

除外してはいけない例:

```text
index.html
assets/
catalog.html
```

## License

MIT

