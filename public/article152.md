---
title: 【Rails】セッション固定攻撃(Session Fixation)
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-02-28T11:51:34+09:00'
id: eace6b9c7e3173a0c695
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。私はアメリカで独学でエンジニアを目指している者です。
前回はRailsにおけるセッションの役割と保存場所について解説しましたが、今回はセッション固定攻撃（Session Fixation）についてご説明いたします。

### セッション固定攻撃とは

セッション固定攻撃とは、**攻撃者があらかじめ用意したセッションIDをユーザーに使用させ、その後ユーザーが認証を行った際に、その固定されたセッションIDに認証情報が紐づいてしまう**攻撃手法です。

なお、セッションハイジャックという手法も存在しますが、こちらは暗号化されていない通信や脆弱なランダム生成アルゴリズムを狙い、セッションIDを盗聴または予測する手法であり、セッション固定攻撃とは異なります。

#### 仕組み
1. 攻撃者があらかじめセッションIDを用意し、URLにセッションを埋め込んだりレスポンスヘッダを追加してCookieを強制する方法などで押し付けます
2. ユーザーがログインすると、セッションIDが再生成されていない場合、その固定されたIDのまま認証情報が紐づく可能性があります。
3. 攻撃者はそのセッションIDを知っているため、ユーザーになりすますことができます。

#### 被害とリスク
- ユーザーアカウントの乗っ取り
- 個人情報や機密情報の漏えい
- 不正操作による損害

---

### Railsでのセッション管理と対策

#### 1. `reset_session` の活用
ログイン時に必ず `reset_session` を呼び出すことで、既存のセッションを破棄し、新しいセッションIDを発行します。これによって、攻撃者が固定したセッションIDは無効化され、ユーザーのログイン後のセッションを保護できます。

##### コード例
```ruby
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      reset_session #これを追加する
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが違います"
      render :new
    end
  end
end
```

#### 2. Cookieのセキュリティ設定

- **Secure属性**：HTTPS通信時のみCookieが送信されるように設定。
- **HttpOnly属性**：JavaScriptからのアクセスを禁止し、XSSによるCookie窃取を防止。

Railsの `config/initializers/session_store.rb` などで設定する例:
```ruby
Rails.application.config.session_store :cookie_store,
  key: '_app_session',
  secure: Rails.env.production?,
  httponly: true
```

#### 3. セッションタイムアウト
一定時間操作がない場合はセッションを破棄し、再度ログインを要求することで、不正なセッション利用を防ぎます。

#### 4. CSRF対策
RailsではデフォルトでCSRFトークンによるフォーム保護が有効です。セッション固定攻撃を直接防ぐものではありませんが、セッションを悪用される一部の攻撃リスクを低減できます。

---

### まとめ

- セッション固定攻撃を防ぐためには、**ログイン後のセッションID再生成（`reset_session`）** が不可欠。
- 併せて、Cookieの属性（`Secure`, `HttpOnly`）やセッションタイムアウトの適切な設定、CSRF対策などを組み合わせることで、総合的にセッション安全性を高められます。Railsの標準機能を活用し、脆弱性のない安全なWebアプリケーションを構築しましょう。

