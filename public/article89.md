---
title: 【Web】プロキシサーバ
tags:
  - Web
  - 初心者
  - proxy
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-26T13:58:42+09:00'
id: 1c91db781d58322a0c33
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指しているものです。
現在Webについて勉強していますが、本日はその中でもプロキシサーバについて説明していこうと思います。
名前は聞いたことあるけど何だっけとなってしまったのでこれを機に記事を書こうと思いました

## プロキシサーバーとは

プロキシサーバーは、クライアントとサーバーの中間でデータの中継・転送を行い、クライアントの代理として通信を行うサーバーです。これにより、クライアントとサーバーが直接通信を行うのではなく、必ずプロキシサーバーを介して通信が行われます。

### プロキシサーバーの分類

プロキシサーバーは大きく分けて以下の2種類に分類されます。

- フォワードプロキシ (Forward Proxy)
- リバースプロキシ (Reverse Proxy)

それぞれの特性や役割は異なり、運用目的や環境に応じて使い分けられます。

---

## フォワードプロキシ (Forward Proxy)

### 概要

フォワードプロキシとは、クライアントの“代理”として外部のサーバーにリクエストを送るプロキシサーバーです。一般的に「プロキシサーバー」と呼ぶ場合、多くはフォワードプロキシを指します。社内LANや特定のネットワーク環境で、外部サイトへのアクセスを管理・制限する目的や、キャッシュ機能を利用した高速化などによく利用されます。

### 主な役割・メリット

#### アクセス制限・フィルタリング

- 社内ネットワークや学校で、不適切なサイトや危険なサイトへのアクセスを制限します。
- フォワードプロキシを通すことで、管理者は誰がどのサイトにアクセスしたかを記録しやすくなります。

#### キャッシュによる高速化

- フォワードプロキシはキャッシュ機能を持つことが多く、頻繁にアクセスされるコンテンツをプロキシサーバー側に保存しておくことで、次回のリクエスト時にプロキシサーバーから直接配信可能です。
- これにより、ネットワーク帯域の節約やレスポンス時間の短縮が実現します。

#### プライバシー保護

- フォワードプロキシを利用することで、クライアントの実際のIPアドレスを隠し、外部サーバーに直接通知されないようにします。
- 匿名性を向上させたい場合に利用されます。

#### 内部ネットワークのセキュリティ強化

- クライアントが外部にアクセスする際、フォワードプロキシを必ず経由させることで、通信の監視や制御が容易になり、セキュリティが向上します。

---

## リバースプロキシ (Reverse Proxy)

### 概要

リバースプロキシはサーバー側に配置され、外部からのリクエストを“代理受信”するプロキシサーバーです。クライアントは通常、リバースプロキシの存在を意識することはありません。表向きには「リバースプロキシ自体がウェブサーバー」のように振る舞い、実際のコンテンツはリバースプロキシの背後にいるサーバー群が提供します。

### 主な役割・メリット

#### ロードバランシング（負荷分散）

- リバースプロキシで複数のバックエンドサーバーにリクエストを振り分け、負荷を均等に分散します。
- 大規模なウェブサービス運用では欠かせない機能です。

#### セキュリティ対策

- クライアントから直接バックエンドサーバーにアクセスさせず、サーバー構成やIPアドレスを隠蔽します。
- 不正アクセスやDDoS攻撃を防ぐためのフィルタリング機能も設定可能です。

#### SSL/TLS終端 (SSL Offloading)

- HTTPS通信の暗号化・復号処理をリバースプロキシで行うことで、バックエンドサーバーの負荷を軽減します。
- SSL証明書を一元管理できるため、運用効率が向上します。

#### キャッシュによる高速化

- リバースプロキシはキャッシュ機能を利用して、静的コンテンツを効率的に配信します。
- バックエンドサーバーの負荷を減らし、クライアントへの応答速度を向上させます。

#### コンテンツルーティング

- リクエストのURLやヘッダー情報に基づいて、適切なバックエンドサーバーに振り分けることが可能です。
- マイクロサービス環境や多言語対応サイトでの柔軟な運用を支援します。

---

## フォワードプロキシとリバースプロキシの対比

| **項目**            | **フォワードプロキシ**                                     | **リバースプロキシ**                                      |
|---------------------|-------------------------------------------------------|--------------------------------------------------------|
| **役割**           | クライアントの代理で外部にアクセスする                     | 外部からのリクエストを受けるサーバーの代理               |
| **配置場所**       | クライアント側のネットワーク境界                           | サーバー側（サービス提供側）のネットワーク境界           |
| **利用目的**       | アクセス制限、キャッシュ、高速化、プライバシー保護など     | 負荷分散、セキュリティ強化、SSL終端、キャッシュなど       |
| **対象**           | 内部ネットワークから外部への通信                           | 外部クライアントからサーバーへの通信                     |

---

## まとめ

プロキシサーバーは、通信経路の中継点としてさまざまなメリットをもたらします。

- **フォワードプロキシ**:
  - クライアントの代理として、アクセス制限やキャッシュによる高速化、プライバシー保護などを実現します。
- **リバースプロキシ**:
  - サーバー側の代理として、負荷分散やセキュリティ強化、SSL終端など、高負荷・高セキュアなサービス提供に欠かせない存在です。


