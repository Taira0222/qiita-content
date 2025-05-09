---
title: 【ネットワーク】サブドメイン
tags:
  - Network
  - 初心者
  - サブドメイン
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-04-14T12:05:06+09:00'
id: 56dd91e3d6f1a3fcee6c
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカに住みながら、独学でエンジニアを目指しているTairaです。
今回は、Webサービス開発者にとって重要な概念の一つである「サブドメイン」について解説します。

---

## サブドメインとは？

サブドメインとは、**ドメイン名を階層的に分けた一部**のことで、主にウェブサイトの構造を整理したり、異なるサービスを分けて管理するために使われます。

例：
```
https://blog.example.com
```
このURLにおいて、
- `blog`：サブドメイン
- `example`：セカンドレベルドメイン
- `.com`：トップレベルドメイン（TLD）

---

## サブドメインの用途と例

| サブドメイン | 用途の例 |
|--------------|----------|
| `www.example.com` | メインのウェブサイト |
| `blog.example.com` | ブログページ |
| `shop.example.com` | ネットショップ |
| `admin.example.com` | 管理者専用ページ |

それぞれ別のアプリケーションやサーバーに接続させることも可能です。

---

## サブドメインとサブディレクトリの違い

| 項目 | サブドメイン | サブディレクトリ |
|------|--------------|------------------|
| 例 | `blog.example.com` | `example.com/blog` |
| 独立性 | 高い（別アプリとして扱える） | 低い（同一アプリ内） |
| サーバー構成 | 別サーバーにできる | 同一サーバー内 |
| DNS設定 | 必要 | 不要 |

用途や開発体制によってどちらを使うかを選択します。

---

## バックエンドエンジニアとして知っておきたいポイント

### ✅ DNS設定
- サブドメインごとにDNSでレコード（A/AAAA/CNAMEなど）を設定できます。
- `api.example.com` と `app.example.com` を別サーバーに振り分けることも可能です。

### ✅ SSL証明書
- 通常の証明書では `example.com` 用と `blog.example.com` 用は別に必要です。
- ただし `*.example.com` のようにサブドメイン全体をカバーする「ワイルドカード証明書」もあります。

### ✅ Webアプリの構成に活用
- サブドメインを活用することで、**マイクロサービス化**や**多言語対応**がしやすくなります。
- 例： `en.example.com`（英語版）、`ja.example.com`（日本語版）など

---

## まとめ

- サブドメインは、ドメイン名を分けて整理・管理するための手段
- Webサービスを分けたり、管理しやすくするために広く使われる
- DNS設定やSSL証明書の知識とセットで理解しておくと、バックエンド開発にも役立つ


