---
title: 【rails】devcontainerで react + rails 開発環境を整えてみた。
tags:
  - Rails
  - 初心者
  - React
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-06-05T12:14:19+09:00'
id: 664aa5d0d8cc78460feb
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
今回は「React（Vite）+ Rails（API モード）+ PostgreSQL」のフルスタック開発環境を、VS Code の DevContainer（Docker）を使って実際に環境構築してみました。
以下にセットアップの方法をまとめたので、作成してみてください

https://github.com/Taira0222/react-rails-devcontainer

---

## ディレクトリ構成

このテンプレートは、以下のようにバックエンド（Rails）とフロントエンド（React）を明確に分離して構築されています。

```
rails-react/
├── backend/                 # Rails API
│   ├── .devcontainer/       # Rails 用 DevContainer
│   ├── Dockerfile
│   └── ...
├── frontend/                # React (Vite)
│   ├── .devcontainer/       # React 用 DevContainer
│   ├── Dockerfile
│   └── ...
├── docker-compose.yml       # Rails・React・DB をまとめて起動
├── .github/workflows/       # (任意)CI 定義 (RSpec, Vitest など)
└── .gitignore               # .env などを除外
```

---

## 特長まとめ

- **VS Code DevContainer 対応**：再現性の高い環境構築が可能。
- **Rails × React 分離構成**：開発・デプロイを独立して実施可能。
- **Docker Compose 利用**：Rails・React・PostgreSQL を簡単に一括起動。
- **ホットリロード・依存キャッシュ対応**：開発効率も抜群です。

---

## セットアップ手順（ローカル開発）

### 1. リポジトリをクローン

```bash
git clone https://github.com/your-username/react-rails-devcontainer.git
cd rails-react
```

### 2. VS Code で DevContainer を開く

- VS Code 拡張機能「Dev Containers」をインストール。
- `code ./backend` や `code ./frontend` で個別に DevContainer を開きます。
- 左下の「><」ボタンや `devcontainer.json` を開くことで、リビルド＆起動可能です。

### 3. 初期化（初回のみ）

#### Rails (backend)

```bash
rails new . --api -d postgresql
```

#### React (frontend)

```bash
npm create vite@latest .
```

### 4. サーバー起動

#### Rails API

```bash
rails s
```

アクセス: [http://localhost:3000](http://localhost:3000)

#### React（Vite）

```json
// package.json
"scripts": {
  "dev": "vite --host"
}
```

```bash
npm run dev
```

アクセス: [http://localhost:5173](http://localhost:5173)

---

## セキュリティと環境変数

- `.env` にデータベース接続情報などの機密情報を記載します。
- `.env` は `.gitignore` に含め、Git に上げないように注意。

```bash
#.gitignore
.env
```

## まとめ

まだ、実際に DevContainer を使って React + Rails の開発はできてませんが、rails や react 単体では現在進行形で使用しており、
かなり快適に開発を進めることができます。

何か気づいた点や改善提案があれば、ぜひコメントください！
