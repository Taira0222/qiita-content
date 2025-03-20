---
title: 【Rails】Railsチュートリアル9章を読み終えて
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-20T11:54:19+09:00'
id: 1f47fc54ff95167802e7
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに
こんにちは。アメリカに住みながら独学でエンジニアを目指している taira です。
Railsチュートリアルを使ってRuby on Railsを学習中で、現在は9章まで進めました。
9章から劇的に難易度が上がると聞いていたので、1〜8章を2周(特に6〜8章は重点的に)復習してから9章に取り組みました。
実際、これまでの章より難しく感じましたが、前の章で学んだ内容が頭に入っていれば十分に理解できると思いました。
今回は、振り返りを兼ねて記事をまとめます。

# 9章のねらい
8章まではセッションを使った基本的なログインの仕組みを実装しました。9章では、その応用として、ブラウザを再起動してもログイン状態を維持できる(remember_me)機能を実装することが目標です。

## Remember me 機能の実装
この章ではRemember me機能を実装しました。大まかな手順は以下のとおりです。
1. ランダムな文字列を生成して記憶トークンとして使う。
2. 記憶トークンをハッシュ化してデータベースに保存する。
3. ブラウザの`cookies`にトークンを保存するときは有効期限を設定する。
4. ユーザーIDを暗号化して`cookies`に保存する。
5. ブラウザに暗号化されたユーザーIDがあれば、復号してデータベースを検索し、ハッシュと一致すればセッションを復元する。

ここでは、記憶トークン(`remember_token`)と記憶ダイジェスト(`remember_digest`)を用います。`remember_token`はUserクラスのインスタンス変数(仮想属性)として、`remember_digest`はデータベースのカラムとして扱います。`has_secure_password`と似ており、`remember_token`は仮想属性としての役割を果たしています。

今回主に変更が加わったのは、`user.rb`、`sessions_controller.rb`、`sessions_helper.rb`です。

### user.rb の変更点
```ruby:user.rb
class User < ApplicationRecord
  attr_accessor :remember_token # remember_token を getter/setter として設定
  ・
  ・
  ・

  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest # 返り値として remember_digest を設定
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # 記憶ダイジェストを再利用しているのは利便性のため
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したら true を返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
```

1. `attr_accessor :remember_token`
   - 仮想属性として `remember_token` を設定し、インスタンス変数のように扱えるようにしています。

2. `User.new_token`
   - クラスメソッドとして `new_token` を作成し、`SecureRandom.urlsafe_base64` によりランダムな文字列を生成します。

3. `remember`
   - 生成したトークンをハッシュ化して `remember_digest` に保存するメソッドです。トークンのハッシュ化には `User.digest` を再利用しています。
   - `self.remember_token` のように `self` をつけないと、ローカル変数扱いとなり、`attr_accessor` で定義したインスタンス変数に代入されなくなる点に注意してください。
   - 最後に `remember_digest` を返すのは、後述の `session_token` に利用するためです。

4. `session_token`
   - 毎回変化するハッシュ値を用いてセッションリプレイ攻撃を防ぐための仕組みです。これまでは `user_id` だけでログインユーザーを判断していたため、トークンの盗難による不正ログインの可能性がありました。

5. `authenticated?`
   - 渡されたトークンと `remember_digest` が一致するかを確認します。Bcrypt 使用時、`nil` に対して照合処理を行うと例外になるため、最初に `remember_digest.nil?` の場合は `false` を返しています。

6. `forget`
   - DB 上に保存されている `remember_digest` を `nil` にしてトークン情報を破棄します。

### sessions_helper.rb の変更点
```ruby:sessions_helper.rb
module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    # セッションリプレイ攻撃から保護する
    # 詳しくは https://techracho.bpsinc.jp/hachi8833/2023_06_02/130443 を参照
    session[:session_token] = user.session_token
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token]   = user.remember_token
  end

  # 記憶トークン cookie に対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      # ログイン済みの場合
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      # ブラウザ再訪問時など、セッションがない場合
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていれば true、その他なら false を返す
  def logged_in?
    !current_user.nil?
  end

  # 永続セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil # 安全のため
  end
end
```

1. `log_in`
   - 今までのログイン処理に加えて `session[:session_token]` に `user.session_token` を保存し、セッションリプレイ攻撃を防ぎます。

2. `remember`
   - `remember` メソッドで DB の `remember_digest` を更新し、`cookies` にも有効期限付きでユーザーID(暗号化)と `remember_token` を保存します。

3. `current_user`
   - セッションまたは `cookies` に保存されているユーザー情報をもとに、現在のユーザーを取得します。演習で追加された `session_token` による認証もここで行っています。

4. `forget`
   - ログアウト時に呼び出され、DB の `remember_digest` と `cookies` の `user_id`、`remember_token` を削除します。

### sessions_controller.rb の変更点
```ruby:sessions_controller.rb
class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      reset_session # セッション ID を更新してセッション固定攻撃を防止
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
```

1. `@user` をインスタンス変数に
   - 統合テスト時にコントローラー内の `@user` にアクセスしたい場面があるため、インスタンス変数にしています。

2. `params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)`
   - ログイン画面のチェックボックスで `remember_me` がオン (1) かオフ (0) かを判別し、Remember me 機能のオン/オフを切り替えます。

## Remember me のテスト
コードを理解するだけでも大変ですが、テストは機能の信頼性を高める上で欠かせません。ここでは、`test_helper.rb`、`sessions_helper_test.rb`、`users_login_test.rb`を使用します。

### `test_helper.rb`
```ruby:test_helper.rb
・
・
・
class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: {
      session: {
        email: user.email,
        password: password,
        remember_me: remember_me
      }
    }
  end
end
```
- 毎回同じようなコードを書くのを避けるため、`log_in_as` メソッドで共通化しています。

### `sessions_helper_test.rb`
```ruby:sessions_helper_test.rb
require "test_helper"

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    # セッションが存在しない状態でも cookies からユーザーを正しく取得できるか
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    # 不正な remember_digest（＝DB 側のトークンのハッシュ値）になった場合にユーザーが認識されないか
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
```
- `post login_path` でセッションが作られるとテストにならないため、`setup` で `remember(@user)` を呼び出してセッション無しの状態を作っています。
- これにより cookies だけでユーザーを判断する状況をテストできます。

### `users_login_test.rb`
```ruby:users_login_test.rb
class UsersLogin < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
end

class RememberingTest < UsersLogin
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remembering" do
    # Cookie を保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path # ログアウトして cookie を削除

    # Cookie 削除後にログイン
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end
end
```
- `login with remembering` では、`cookies[:remember_token]` と `assigns(:user).remember_token` が一致するかを確認します。
- テストで使っている `@user` と、コントローラー内で実際にログイン処理によって生成された `@user` (assigns(:user)) は別物である点に注意してください。ログインの過程で実際にトークンが生成されるのはコントローラーの `@user` なので、そちらの `remember_token` と cookies を比較するのが正しい検証です。
- `login without remembering` では、一度 Remember me でログインしてからログアウトし、再度 Remember me をオフにしてログインした場合の `cookies[:remember_token]` が空かどうかをチェックします。

# まとめ
9章では `cookies` を用いた Remember me 機能を実装しました。セキュリティの観点からも学ぶことが多く、一度では理解しきれない部分があるかもしれませんが、復習を重ねることで定着させることが大事だと思います。次の章に進んだら、また記事を更新する予定ですのでお楽しみに！

