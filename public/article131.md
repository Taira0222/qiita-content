---
title: 【Rails】has_secure_passwordの性質
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-02-06T11:43:57+09:00'
id: 9f80185866484eccd2f3
organization_url_name: null
slide: false
ignorePublish: false
---
## はじめに

こんにちは。アメリカで独学でエンジニアを目指している者です。現在は Rails チュートリアルを使って学習を進める中で、`has_secure_password` のテスト時の扱いについて調べました。以下に、テストで使用する際の注意点をまとめています。

## has_secure_passwordの注意点

Rails の `has_secure_password` を使用したモデルをテストするときには、いくつか押さえておきたいポイントがあります。特に、テスト環境と本番環境の挙動の違いを理解しておくとスムーズです。

##  `password` と `password_confirmation` の扱い

通常、アプリケーション内でユーザーを新規作成する際には、`password` と `password_confirmation` を渡すだけで自動的にハッシュ化され、`password_digest` カラムに保存されます。しかしテスト環境では、バリデーションやコールバックの動きが本番と異なる場合があるため、注意が必要です。

## Fixture を使う場合

### `password_digest` を事前に用意する必要

Rails のフィクスチャを用いてユーザーを登録する場合、通常のコールバックによるハッシュ化処理は実行されません。そのため、**あらかじめハッシュ化したパスワード**を `password_digest` に代入する必要があります。

```ruby
class User < ApplicationRecord 
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
```

```yaml
# users.yml
michael:
  name: "Michael"
  email: "michael@example.com"
  password_digest: <%= User.digest("password") %>
```

このように ERB を使って `User.digest("password")` を呼び出すことで、事前にハッシュ値を生成し、フィクスチャに埋め込むことができます。


### ログインを想定する

以下のような統合テストを用いることで、実際のログイン機能が正しく動作しているかを確認できます。

```ruby
require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael) # fixture/user.ymlで定義したmichaelのレコードを取得
  end

  test "login with valid information" do
    post login_path, params: { session: { email: @user.email, password: 'password'} }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end
```

- `post login_path, params: ...` によりログインフォームからのリクエストをシミュレートします。
- フィクスチャから読み込んだユーザー（`@user`）に対し、平文パスワードを渡して認証し、成功時はユーザーの詳細画面にリダイレクトされるかをテストします。
- `assert_select`によるリンクの有無の確認で、ログイン状態であることを検証します。

## テスト速度に関する考慮

`has_secure_password`は内部的にbcryptを利用するため、テストの回数が多いほどパスワードのハッシュ化で時間がかかる可能性があります。テスト速度を意識する場合は、本番環境よりもコストを下げる設定が有効です。
`User.digest`ではそれが考慮されたコードになっています

```ruby
# config/environments/test.rb
Rails.application.configure do
  # bcryptのコストを下げる
  ActiveModel::SecurePassword.min_cost = true
end
```

## まとめ

1. テストでは`password`と`password_confirmation`を正しく指定する。
2. Fixtureを使う場合は**あらかじめハッシュ化された**パスワードを`password_digest`に登録する必要がある。
3. ログイン処理のテストでは、正しいメールアドレスとパスワードを送信し、リダイレクトやリンクの表示などを確認する。
4. テスト速度を意識する場合は`ActiveModel::SecurePassword.min_cost`の設定を利用する。



