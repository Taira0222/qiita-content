---
title: 【Rails】Railsのセッション固定とセッションハイジャックを防ぐ方法
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-04-01T12:10:36+09:00'
id: da113cfa7300f9d3f20e
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカに住みながら独学でエンジニアを目指しているTairaです。

Railsのアプリケーション開発において、セキュリティ対策は必須で、セッション固定攻撃とセッションハイジャック攻撃の対策について記事にしたいと思います。

## 1. セッション固定攻撃とは？

セッション固定攻撃（Session Fixation Attack）とは、攻撃者が特定のセッションIDをユーザーに意図的に使わせ、そのセッションIDでログインさせることでユーザーのセッションを奪う攻撃手法です。

### 対策方法：reset_session

Railsでは、`reset_session` メソッドを使うことで、この攻撃を防ぐことができます。これは、現在のセッションIDを無効にし、新しいセッションIDを発行するものです。

```ruby
# パスワード変更やログイン成功時に使う
reset_session
```

- ユーザーがログインに成功したときや、パスワード変更後にこのコードを実行することで安全性を高めます。

## 2. セッションハイジャックとは？

セッションハイジャックとは、攻撃者がユーザーのCookie（特に永続的なセッション認証情報）を盗み、そのCookieを使って正規ユーザーになりすます攻撃です。

### 対策方法：remember_digestを無効化

Railsで永続セッションを使う場合、一般的には以下のようにCookieとデータベースのremember_digestを利用して実装します。

- Cookieにはremember_tokenを保存
- DBにはremember_digestを保存
- ログイン時に両者を比較してユーザーを認証

もし攻撃者がremember_tokenを盗んだ場合、サーバー上のremember_digestを削除することで攻撃者の永続セッションを無効にできます。

```ruby
# user.rb

def forget
  update_attribute(:remember_digest, nil)
end

# パスワード変更時のコントローラなどで呼び出す
@user.forget
```

この方法を使えば、攻撃者が取得済みの永続セッション情報が無効になるため、セッションハイジャックを防ぐことができます。

## まとめ

Railsアプリケーションでは、

- セッション固定攻撃には `reset_session`
- セッションハイジャックには `remember_digest` の無効化（`@user.forget`）

という2つの手法を使い分け、組み合わせることで安全なセッション管理を実現できます。
