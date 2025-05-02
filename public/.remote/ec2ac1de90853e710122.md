---
title: 【ネットワーク】nslookupコマンド
tags:
  - Network
  - 初心者
  - nslookup
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-03T06:45:40+09:00'
id: ec2ac1de90853e710122
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

※5/1 に投稿する内容でしたが、GitHub Actions の PAT 設定不具合により 5/2 にまとめて投稿しています。

こんにちは。アメリカに住みながら、独学でエンジニアを目指している Taira です。
現在インターネットクイズを定期的に自分に課しているのですが、その中で出てきた nslookup についてまとめようと思います

# nslookup コマンドとは？

ドメイン名から IP アドレスを調べたり，IP アドレスからドメイン名を調べたりする際に便利なツールが「nslookup」です。

## nslookup と DNS の違い

- **DNS**: インターネット上で「ドメイン名」と「IP アドレス」を結びつける仕組み
- **nslookup**: DNS サーバーに問い合わせをして、答えを表示するツール

つまり、**DNS が仕組み，nslookup がそれを利用する手段**です。

## 使い方

### 1. ドメイン名から IP アドレスを調べる

```bash
nslookup example.com
```

### 2. IP アドレスからドメイン名を調べる

```bash
nslookup 93.184.216.34
```

### 3. 特定の DNS サーバーを使って調べる

```bash
nslookup example.com 8.8.8.8
```

(Google Public DNS を使う例)

## 実際の出力例

```bash
nslookup google.com

サーバー:  one.one.one.one
Address:  1.1.1.1

権限のない回答:
名前:    google.com
Addresses:  2607:f8b0:400a:800::200e
            142.250.217.110

```

- 使用 DNS サーバーは 1.1.1.1（Cloudflare の高速 DNS）

- サーバー名も正しく取得（one.one.one.one）

- Google の正しい IPv4 アドレス（142.250.217.110）と IPv6 アドレスが返ってきた

## nslookup を使う場面

| 場面                       | 目的                                   |
| :------------------------- | :------------------------------------- |
| ネットワーク障害の課題分析 | DNS トラブルなのか別問題かを分析       |
| サーバー移行確認           | 新しい IP アドレスへ切り替わったか確認 |
| DNS キャッシュ確認         | DNS の更新が送れているかを確認         |
| MX レコードの調査          | メール送信先を調べる                   |
| 反対に IP から調べる時     | 不安な IP アドレスの調査               |

## まとめ

- **nslookup**は、DNS リゾルバと同じような動作を「手動」で行うツール
- ネットワークト問題の課題分析やサーバー切替確認に必須
- 正常時は使わないが、一旦問題が発生したら、最初に使うべきツール
