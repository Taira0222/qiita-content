---
title: 【Rails】テストのgetが行っていること
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-02-11T11:45:51+09:00'
id: 5b39515b2d58342c8aff
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカで独学でエンジニアを目指している者です。
現在、Rails とネットワークを合わせて勉強しており、HTTP リクエストについても知っていたつもりでした。しかし、Rails のテストコードにおける `get home_path` の動作を正しく理解できていなかったため、本記事で整理してみたいと思います。

よくある技術書には「GET は最もよく使われる HTTP リクエストで、URL をクリックするときに使用される」と書かれており、そこから「画面を表示するまでの機能を持っている」と勘違いしてしまいました。こうした背景を踏まえて、本記事では Rails のテストで使われる `get` メソッドの正しい動作を説明します。

## Railsのテストコード

Railsのテストを書くとき、コントローラのアクションに対して以下のように書くことがよくあります。

```ruby
test "should get home" do
  get home_path # route.rbでは get '/home', to: 'static_pages#home' と定義されている
  assert_response :success
end
```
一見すると「`get home_path` を呼び出すと `/home` にアクセスしてページを表示している」ように見えるかもしれません。
しかし、テスト環境での get はブラウザを使ったページ表示とは異なる動きをしています。

## `get home_path` が行うこと
* `get` は、テスト環境のRailsサーバーに対して**HTTP GETリクエスト**を送信するためのメソッドです。
* 本番環境でブラウザが「https://example.com/static_pages/home にアクセスする」動作を、テスト環境でシミュレーションしているようなイメージです。

ただし、実際にはブラウザは使われません。あくまで**テストコード内でリクエストとレスポンスのやり取りがシミュレートされるだけ**です。したがって、画面が表示されたり、HTML がレンダリングされるわけではありません。代わりに「どのアクションが呼び出され、どんなレスポンスが返ってきたのか」を検証するのがテストの目的です。

## テスト環境の流れ
テスト環境で `get home_path` が呼ばれると、実際には以下のように処理が進みます。

1. `get home_path`
`/home` に該当するURLに向けてHTTPリクエストを送るよう、内部的にシミュレートします。
Railsはテスト環境用に立ち上がったサーバーへ、リクエストが送られたとみなして処理を進めます。

2. Railsがコントローラ（StaticPagesController#home）を呼び出す
ルーティング設定に従い、`static_pages#home` アクションにリクエストを振り分けます。
コントローラが処理を行い、最終的にレスポンスを返します。

3. テストはレスポンスを検証
`assert_response :success` などを使い、レスポンスのステータスコードが 200 であることを確認します。
必要に応じて `assert_select` を用いて HTML 内の要素をチェックしたり、リダイレクトを `assert_redirected_to` で検証することもできます。

これらのプロセスは**すべてブラウザを介さずに行われ、テストフレームワーク内で完結している**のがポイントです。
これについて説明していきます

###  具体例
以下は8章で出てくるflashという一時的にメッセージを表示するものです。

```ruby
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
    # エラーメッセージを作成する
      flash[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
  end
end
```
`flash`は、新たなリクエストが送信された際に表示され、その後チェック済みとして消える仕組みになっています。
しかし、上記のコードでは、`flash[:danger] = 'Invalid email/password combination'`の後に`render`が呼ばれており、これはリクエストを再送信するのではなく単に`new`アクションを表示するだけなので、`flash`は消去されません。

ここまでの説明は以上にして、本題である、テスト内で`get home_path`（今回は`root_path`を使用）の挙動について説明します。
```ruby
require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: ''}}
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
```

ここで、テスト内の最後の2行である`get root_path`と`assert flash.empty?`に注目してください。
`flash.empty?`は、`flash`に何も設定されていなければ`true`を返すメソッドであり、その結果が`true`であることを`assert`で確認しています。
しかし、実際には`flash.empty?`の結果は`false`となり、このテストは失敗します。

もし`get root_path`がブラウザを介して新たなリクエストを送信しているのであれば、`flash`が初期化され`flash.empty?`が`true`となりテストは成功するはずです。
しかし、前述の通り、`get root_path`は**テストフレームワーク内で完結しており、実際の新しいリクエスト送信が行われていない**ため、`flash`は消去されないことが確認できます。

## 本番環境での流れ
一方、本番環境（または開発環境）でユーザーがページを閲覧する場合は、以下のフローになります。

1. ユーザーがブラウザから /static_pages/home のURLへアクセス
2. ブラウザがサーバーにHTTP GETリクエストを送信
3. サーバー側で該当コントローラのアクション（StaticPagesController#home）が呼び出される
4. アクションがビューを描画し、HTMLを生成してブラウザに返す
5. ブラウザがHTMLを受け取って画面を描画し、ユーザーにページが表示される

このように、本番・開発環境では実際にブラウザが HTML を描画し、ユーザーが画面を見る流れになります。

## 「get がページを表示する」と思いがちな理由
テストで get を呼んだ後、レスポンスを検証しているため、本番環境と似たような動きを想像してしまいがちです。しかし、テストコード内では、リクエストとレスポンスをシミュレーションして確認しているだけであり、実際のブラウザ表示は行われていません。

つまり、「get がページを表示している」のではなく、「**get がサーバーにリクエストを送り、返ってきたレスポンスが 200 かどうかなどをテストで確認している**」という認識が正しいのです。

# まとめ
1. テスト環境
`get home_path` は URL に対して HTTP GET リクエストをシミュレーションするメソッド。
**ブラウザを使用せず**、ステータスコードやレスポンス内容をテストで検証する。
2. 本番環境
ブラウザからサーバーへ本物のリクエストが飛び、返ってきた HTML をブラウザが描画し、ユーザーがページを閲覧する。

Rails テストを始めたばかりの頃は、「get はページを表示するためのメソッド」と勘違いしてしまいがちです。しかし、実際には 「HTTP リクエストとレスポンスをシミュレーションして、その動作をテストするためのもの」 だという点を理解しておくと、テストの役割や仕組みがより明確になります。
