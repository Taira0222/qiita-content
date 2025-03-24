---
title: 【Rails】テストではfollow_direct!が必要
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-24T12:00:49+09:00'
id: ceee514b969b3d45514c
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに
こんにちは。アメリカに住みながら独学でエンジニアを目指している taira です。
本日はテストでリダイレクトをする際には明示的に`follow_redirect!`を書く必要があると知り、とても勉強になったので、実例を交えてまとめてみようと思いました。

## テストコードの意図

Railsチュートリアルで出てきた課題で、以下のような意図を持った統合テストコードを書こうと思いました。

1. ログイン処理
2. `user_path(@user)` へリダイレクト
3. 画面にあるリンクをそれぞれ確認

ちなみにログイン処理(`log_in_as`)を呼び出すと、次のメソッドが実行されます。

```ruby
def create
  @user = User.find_by(email: params[:session][:email].downcase)
  if @user&.authenticate(params[:session][:password])
    forwarding_url = session[:forwarding_url]
    reset_session
    params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    log_in @user
    redirect_to forwarding_url || @user # ここでリダイレクトしている
  else
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new', status: :unprocessable_entity
  end
end
```

上記のコードでは、条件を満たしていれば `forwarding_url` もしくは `@user` にリダイレクトします。

## 私が書いたテストコード

```ruby
require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'logged in user layout' do
    log_in_as(@user)
    assert_redirected_to @user # リダイレクトしている？
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
  end
end
```

上記は統合テストですが、当初、私は `assert_redirected_to` でリダイレクト処理が完了していると思っていました。そのためテストを実行するとエラーが発生。
実は `assert_redirected_to` はリダイレクトを実行するのではなく、**コントローラーのアクションがリダイレクトレスポンスを返したかどうかと、リダイレクト先が想定のURLかどうかをチェックするメソッド** です。

つまり、`assert_redirected_to` だけではリダイレクトは実際に行われないので、以下のように `follow_redirect!` を書く必要があります。

```ruby
log_in_as(@user)
assert_redirected_to @user
follow_redirect!  # ← この一行が必須
assert_template 'users/show'
```

## なぜcreateメソッドには `follow_redirect!` がないのか

テストで `follow_redirect!` が必要なことは理解できましたが、では `create` メソッドにも `redirect_to forwarding_url || @user` の後に `follow_redirect!` が必要なのでは？ と思うかもしれません。

ここでは、次の2つの違いを理解しておくことが重要です。

1. ブラウザ（開発環境・本番環境）
2. 統合テスト

### ブラウザ（開発・本番）の場合

ブラウザがRailsアプリと通信する際、処理の流れは以下のようになっています。

1. ブラウザでフォーム送信（POST）
2. Railsからレスポンスが返ってくる（ステータスコード302、リダイレクト先URL）
3. ブラウザはRailsからのレスポンスを解釈し、自動的にリダイレクト先に対して新たにGETリクエストを送信
4. リダイレクト先ページのHTMLを取得・表示

つまり、ブラウザはRailsからのリダイレクト指示を受け取ると**自動的に転送先URLへリクエストを送る**仕組みを持っています。これが、開発や本番環境で `follow_redirect!` が不要な理由です。

### 統合テストの場合

一方、統合テストではブラウザのような自動リダイレクト処理を行う仕組みがありません。

- テスト側からPOSTリクエストを送信 → Railsがリダイレクト指示を返す（ここで処理が止まる）
- テストコード側で明示的に「リダイレクト先URLを取得してほしい」と指示する必要がある

このため、Railsの統合テストでは `follow_redirect!` が用意されており、
「リダイレクト先へ移動する」という操作をテストコード側で書く必要があります。

## まとめ

テストコードでリダイレクト先を確認したい場合、`assert_redirected_to` は「リダイレクトレスポンスを返したかどうか」を確認するためのメソッドであり、実際にリダイレクト先に移動するわけではありません。そのため、リダイレクト後のページ内容まで確認する際には `follow_redirect!` が必要です。

- **ブラウザ（開発・本番環境）** では、リダイレクト指示（302）を受け取ったとき、ブラウザが自動で転送先にアクセスしてくれる。
- **統合テスト** では、自動リダイレクトが行われないので、自分で `follow_redirect!` を書いて明示的に次のページを取得しに行く必要がある。


