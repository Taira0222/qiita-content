---
title: 【セキュリティ】Basic認証
tags:
  - Security
  - 初心者
  - Basic認証
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-06T12:06:33+09:00'
id: f80c37d953cba0b8ac7b
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカに住みながら、独学でエンジニアを目指している Taira です。
現在セキュリティについて、徳丸本を使用しながら学習中ですが、そこで出てきた Basic 認証についてまとめてみようと思います。

## Basic 認証とは？

Basic 認証（Basic Authentication）は、Web サイトにアクセスする際に**ユーザー名とパスワードで認証**を行う仕組みの 1 つです。**HTTP リクエストの`Authorization`ヘッダーに、ユーザー名とパスワードを Base64 エンコードして送信する**ことで認証を実現します。

---

## Basic 認証の仕組み

1. クライアントが保護されたページにアクセスする
2. サーバーが `401 Unauthorized` を返し、`WWW-Authenticate: Basic realm="..."` ヘッダーで認証を要求
3. クライアントは、ユーザー名とパスワードを `:` でつなぎ、Base64 エンコードした文字列を `Authorization` ヘッダーに含めて再送信

```http
Authorization: Basic dXNlcjpwYXNz
```

4. サーバーが認証情報を検証し、正しければリソースを返す

※ `dXNlcjpwYXNz` は「user\:pass」を Base64 でエンコードした例

---

## Basic 認証の注意点

| 問題点               | 説明                                                                       |
| -------------------- | -------------------------------------------------------------------------- |
| 暗号化されていない   | Base64 はエンコードであり暗号化ではないため、情報は簡単に復元可能          |
| HTTP では危険        | HTTPS を使わないと、通信中に認証情報が盗聴されるリスクがある               |
| セッション管理がない | 毎回認証情報を送る必要があり、ログアウト処理もできない                     |
| UI が固定される      | ブラウザのデフォルトの認証ダイアログしか使えないため、柔軟な UI が作れない |

---

## 実際の使用例（Apache の場合）

`.htaccess` ファイルで簡単に Basic 認証をかけられます。

```apacheconf
AuthType Basic
AuthName "Restricted Area"
AuthUserFile /path/to/.htpasswd
Require valid-user
```

`.htpasswd` ファイルには、ユーザー名とハッシュ化されたパスワードを記述します。

---

## どんなときに使う？

Basic 認証は、以下のような**限定的・一時的な用途**で使われることが多いです。

- 社内用の開発環境やステージングサイトの保護
- API への簡易的なアクセス制御（本番では推奨されない）
- 一時的に公開を制限したい静的サイト

---

## GET でも POST でも使える

Basic 認証は、HTTP メソッド（GET, POST, PUT など）に関係なく、**すべてのリクエストで共通して使用可能**です。

```http
GET /secret/page HTTP/1.1
Authorization: Basic dXNlcjpwYXNz

POST /submit HTTP/1.1
Authorization: Basic dXNlcjpwYXNz
Content-Type: application/json

{"message": "Hello"}
```

---

## ログアウトができない？

Basic 認証は**一度認証されると、ブラウザが認証情報をキャッシュ**します。明示的にログアウトする仕組みがないため、ログアウトしたい場合は以下のような工夫が必要です。

- ブラウザを再起動する
- 認証情報を含まない URL にリダイレクトする
- JavaScript で `window.location` にダミーの認証情報を埋め込む（やや強引）

---

## まとめ

| 項目         | 内容                                             |
| ------------ | ------------------------------------------------ |
| 認証方式     | Authorization ヘッダーに Base64 で認証情報を送る |
| セキュリティ | HTTPS 必須。HTTP では盗聴リスクが高い            |
| ログアウト   | 明示的に行えない（ブラウザの仕様）               |
| 用途         | ステージング環境、社内ツールなどの簡易認証       |
