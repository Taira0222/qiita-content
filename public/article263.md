---
title: 【rails】Google認証のテスト(minitest)
tags:
  - Rails
  - devise
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-06-20T12:15:04+09:00'
id: 386c5e43e67dd2f01803
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに
こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。

現在devise を用いてrails アプリを作成中ですが、ログインの認証にgoogle OAuth を取り入れてみました。

minitest でgoogle OAuth のテストケースを書いた記事があまりにも少なかったので、記事にするいい機会だと思いました。

なお、前提としてGoogleログインをOmniAuth + Deviseで実装していることを前提とします（OmniAuthのコールバックURLなどが定義されている状態）。

## Google OAuth の実態

Rails アプリで Google ログインを使うとき、通常は以下のようなフローになります：

1. ユーザーが Google にリダイレクト
2. Google で認証後、認可コードを Rails に返す
3. Rails はそのコードを使ってトークンを取得
4. 最終的にログイン処理へ

でも、**テスト時に実際に Google サーバーに接続するのは現実的ではありません**。
➡ だからこそ、「Google からこんなデータが返ってきたことにしよう」という **モック（偽物）データ** を用意するわけです。

---

## OmniAuthのmock設定

テストを書く前にtest\_helper.rbに以下を記述してください

```ruby
# test/test_helper.rb
OmniAuth.config.test_mode = true
```

`test_mode = true` でOmniAuthをmockモードにしてください

---

## Minitestコード例

```ruby
require "test_helper"

class GoogleAuthTest < ActionDispatch::IntegrationTest
  # google認証 true & user.persist? true
  test "valid infomation google auth" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: "google_oauth2",
    uid: "1234567890",
    info: {
      name:  "test_user",
      email: "test@example.com"
    }
  })
    assert_difference "User.count", 1 do
      get user_google_oauth2_omniauth_callback_path
      follow_redirect! # userのパスにリダイレクト
      follow_redirect! # today_pathへリダイレクト
    end
    assert_equal I18n.t("devise.omniauth_callbacks.success", kind: "Google"), flash[:notice]
    assert_template "lists/today"
    assert_match    "test_user", response.body
    assert User.exists?(email: "test@example.com")
  end
```

---

## 失敗範囲のテスト

失敗情報をmockで作成する場合:

```ruby
OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
```

これにより、認証失敗時の振る舞いもテスト可能になります。

ここで、注意点ですが上記は認証失敗をテストするのであって、以下の`OmniauthCallbacksController`の`else` をテストしているわけではありません。

`else` は認証は問題なかったけど、`@user.persisted?` に問題があった処理であることを忘れないでください。

```ruby
def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to request.referer || new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
end
```
なので、もし`else `をテストする場合は以下のようなテストになるはずです

```ruby
# google認証 true & user.persist? false
test "success google authorization but failed save user " do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: "google_oauth2",
    uid: "1111",
    info: {
      name: nil,
      email: nil
    }
  })
  assert_no_difference "User.count" do
    get user_google_oauth2_omniauth_callback_path
  end
  assert_redirected_to new_user_registration_url
  assert_match "メールアドレスを入力してください\n名前を入力してください", flash[:alert]
end
```

---

## おわりに

Google OAuthのような外部サービス連携のテストは、mockを利用することでテストをすることが可能です

