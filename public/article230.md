---
title: 【rails】devcontainer開発でbin/dev、bin/rails のbinを省略できる方法
tags:
  - Rails
  - 初心者
  - bin
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-18T12:15:36+09:00'
id: 9fc8b206f27e028c72bd
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
Rails 開発において `bin/rails` や `bin/dev` のように、`bin/` ディレクトリを毎回コマンドに付けるのは、正直手間ですよね。

特に VS Code の devcontainer（「Reopen in Container」）を使っている場合でも、この省略方法を知っておくと開発効率が上がります。この記事では「なぜ bin/が必要なのか」と「省略する具体的な方法」をまとめます。

---

## なぜ bin/を付ける必要があるのか

Rails 5 以降、アプリの bin 配下に `rails` や `dev`、`rake` などの実行ファイルが自動生成されるようになりました。

```bash
bin/rails server
bin/dev
```

- プロジェクトごとにバージョン依存を管理するため
  グローバルな rails コマンドではなく、そのアプリ専用のバージョンで実行できるようにするためです。

- Binstub 経由の実行を推奨する流れ
  開発環境ごとの差異によるトラブル防止や、Bundler の恩恵を最大限に受けるためです。

---

## devcontainer での設定方法

VS Code の devcontainer 環境だと、コンテナを起動するたびに PATH の設定がリセットされる場合があります。
そこで、`devcontainer.json` の `postCreateCommand` を使って PATH 設定を自動化するのがベストです。

例：devcontainer.json

```json
"postCreateCommand": "echo 'export PATH=./bin:$PATH' >> ~/.bashrc"
```

#### 注意点

- `./bin` はカレントディレクトリに依存します。`~/.bashrc` や `~/.zshrc` に追加することでシェル起動時に自動で PATH が通ります。

- ログインシェルとして起動していない場合（ターミナルで source ~/.bashrc などを手動実行しない場合）、新しいターミナルで反映されることを確認してください。
