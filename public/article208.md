---
title: 【ネットワーク】CORS
tags:
  - Network
  - 初心者
  - CORS
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-04-25T12:04:15+09:00'
id: 0cd4bb2a6ac71594536c
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカに住みながら、独学でエンジニアを目指しているTairaです。

現在インターネットの知識の確認するインターネットクイズを定期的にやっているのですが、そこで出てきたCORSについて説明していきたいと思います

## CORSの説明の前に

CORS（Cross-Origin Resource Sharing）を説明する前に、オリジンについて説明します。
オリジンは一般的に以下の3つを合わせたものを指します

- **スキーム** (http/または https)
- **ドメイン名/IP** (localhost, example.com など)
- **ポート番号** (3000, 5173 など)

これらの任意の1つが異なると、別オリジンとして取り扱われ、JavaScriptからのリクエストをブロックするという機能をブラウザが標準搭載しています(**同一オリジンポリシー（SOP）の制限**)。

## なぜCORSが必要か

通常、ブラウザはセキュリティ上の理由から、異なるオリジン間での通信を制限しています（たとえば、example.com のページが api.example.net にアクセスすることは制限される）。
例えば以下のようなフロントとバックエンドを分けてAPIで接続するようなアプリを考えてみます。

- フロントエンド（Reactなど）が [http://localhost:5173](http://localhost:5173) で動作
- バックエンド（Railsなど）が [http://localhost:3000](http://localhost:3000) にある

この場合、ポートが違うのでオリジンが異なると見なされます。このとき、フロントエンドからAPIへアクセスすると、CORSエラーになります。

## そこでCORSが役に立つ

それらのような、異なるオリジン（ドメイン、ポート、プロトコルが異なる）間でのリソースの共有を可能にする仕組みをCORSといいます。
ブラウザのセキュリティ機能の一部であり、\*\*同一オリジンポリシー（SOP）\*\*の制限を一部緩和するために使われます。

### セキュリティ例:

ユーザーが [https://mybank.com](https://mybank.com) でログインしている時、別のWebサイト evil.com が JavaScriptを使って、勝手に mybank.com のAPIへ送金リクエストを投げるとします。

このような攻撃は current\_user やセッションIDを使った障害行為を実行できるため、CORSのようなブラウザ側の防衛系統が必須なのです。

## React と Rails を分離して開発する場合

React(フロントエンド): [http://localhost:5173](http://localhost:5173)
Rails(APIバックエンド): [http://localhost:3000](http://localhost:3000)

これらはポートが違うため、同じPCで動いているとしても別オリジンとして扱われます。
そのためCORSの設定をRails側で行う必要があります。

### 例: `config/initializers/cors.rb`

```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
```

## 補足: CORSエラーのよくある原因と対応

### 1. フロントエンドのリクエストに `credentials: 'include'` が設定されていない

CORSでCookieやセッション情報をやり取りする場合、フロントエンド側でも以下のように `credentials: 'include'` を明示する必要があります。

```javascript
fetch('http://localhost:3000/api/example', {
  method: 'GET',
  credentials: 'include'
})
```

### 2. `credentials: true` を設定しているのに `origins '*'` にしている

Rails側で `credentials: true` を設定する場合、オリジンをワイルドカード（`'*'`）にするとエラーになります。必ず具体的なオリジン（例：`http://localhost:5173`）を指定しましょう。

### 3. `OPTIONS`メソッドへの対応が不足している

ブラウザは "事前リクエスト（preflight）" として `OPTIONS` リクエストを送る場合があります。このため、Rails側で `:options` を明示的に許可しておく必要があります。

```ruby
methods: [:get, :post, :put, :patch, :delete, :options, :head]
```

### 4. 本番環境でのドメイン指定忘れ

本番では `localhost` ではなく、本番のURL（例：`https://myapp.com`）を指定する必要があります。複数環境に対応するには、環境ごとに切り替えるように設定を工夫しましょう。



