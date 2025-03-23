---
title: 【Rails】フレンドリーフォワーディングとは
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-23T12:01:13+09:00'
id: 3c5098aee72ad63d6ba3
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに
こんにちは。アメリカに住みながら独学でエンジニアを目指している taira です。
現在Ruby on Railsを使用して学習中ですが、そこで出てきたフレンドリーフォワーディングについて自分なりに整理してみました

## フレンドリーフォワーディングとは
フレンドリーフォワーディングとは、「ログインが必要なページ」にアクセスしようとした未ログインユーザーを一度ログインページに誘導した後、ログインが成功したら最初にアクセスしようとしたページへ自動的に戻す仕組みです。
ユーザー体験を向上するために取り入れる仕組みになっています。

例を挙げると、以下のような状況でフレンドリーフォワーディングを行います
1. 未ログインのユーザーが「プロフィール編集ページ」にアクセス。
2. ログインしていないのでログインページに強制リダイレクト。
3. ユーザーがログインすると、再び「プロフィール編集ページ」へと自動的に遷移する。

## 実装方法
Railsチュートリアルでは、コードの実装の前にテストコードを書いています。
テストコードはシンプルなので、詳しくは本編をご覧ください。

実装の手順としては以下の通りです。
1. `sessions_helper.rb`で`session`にログイン画面に飛ぶ前のリンクを保存する`store_location`メソッドを定義する
2. `users_controller.rb`で`store_location`を呼び出す
3. `sessions_controller.rb`の`create`メソッド(ログインボタンを押したときに呼び出される)に、`store_location`メソッドで保存した`URL`を呼び出し、リダイレクトする。

### 1. `sessions_helper.rb`で`session`にログイン画面に飛ぶ前のリンクを保存する`store_location`メソッドを定義する
```ruby
module SessionsHelper
 .
 .
 .
  #アクセスしようとしたURLを保存する
  def store_location
    session[:forwarding_url]= request.original_url if request.get?
  end
end
```
`request.original_url`を使用することで、ログイン画面にリダイレクトする前のURLを取得することができます。
`request.get?`としているのは、例えばDELETEリクエストのリンクを取得してしまったら、ログインしたのに情報が削除されるという予期しない動作をすることになるので、GETメソッドのみにしています

### 2. `users_controller.rb`で`store_location`を呼び出す
```ruby
#ログイン済みユーザーかどうか確認
def logged_in_user
  unless logged_in?
    store_location # 追加
    flash[:danger]= "Please login."
    redirect_to login_url, status: :see_other
  end
end
```

`redirect_to` でログイン画面にリダイレクトするので、その前に`store_location`メソッドで`session[:forwarding_url]`でリンクを保存しておきます

### 3. `sessions_controller.rb`の`create`メソッド(ログインボタンを押したときに呼び出される)に、`store_location`メソッドで保存した`URL`を呼び出し、リダイレクトする。

```ruby
def create
  user = User.find_by(email:params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password])
    forwarding_url = session[:forwarding_url] # 追加
    reset_session
    params[:session][:remember_me] == '1' ?remember(user) :forget(user)
    log_in user
    redirect_to forwarding_url || user # 追加
  else
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new', status: :unprocessable_entity
  end
end
```

上記の`forwarding_url`の位置ですが、`reset_session`の後だとセッションがリセットされてしまった後になるので、その前にローカル変数に代入する必要があります。
`redirect_to`で`forwarding_url`に値が入っていれば、ログイン前に飛ぼうとしたリンクへリダイレクトします。

## リダイレクトでほかのページに飛ぶことはできないのか
`redirect_to edit_user_path(@user)`のように決まった場所にリダイレクトしてしまえば、わざわざURLを保存する必要はないのでは？と最初見たときは思いました。
実際にすることは可能ですが、わざわざ元のURLを一度保存してまでフレンドリーフォワーディングを使う主な理由は、**「ログインが必要なページがひとつではなく、たくさんあるため」**です。

例えば、次のような状況を考えます。

あなたのRailsアプリに以下のページがあるとします

- プロフィール編集ページ（`edit_user_path`）
- 投稿作成ページ（`new_post_path`）
- 設定変更ページ（`settings_path`）
- 特定の投稿の編集ページ（`edit_post_path(post)`）

上記すべてログインを要求するページである場合を想像してみましょう。

もしURLを保存しない方法を取った場合、どうなるでしょうか？

`edit_user_path` にアクセス → ログイン要求 → ログイン後に `redirect_to edit_user_path`でOK
しかし、`new_post_path`にアクセス → ログイン要求 → ログイン後、`edit_user_path`に戻される？
後者の場合、ユーザーが望んだページと異なるページへ遷移するため、ユーザーにとって混乱やストレスになります。
ページごとに決め打ちの`redirect_to`を設定していては、すべてのパターンを網羅する必要があり、コードも複雑化します。

## まとめ
フレンドリーフォワーディングによって、ユーザーはログイン後に元々アクセスしようとしていたページへスムーズに戻ることができます。これにより複数のページでログインを要求する場面でも、ユーザーの混乱や操作の手間を軽減することが可能です。実装方法は比較的シンプルであり、Railsチュートリアルを参考にしながら、自身のアプリケーションに合わせてカスタマイズしてみてください。

