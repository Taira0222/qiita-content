---
title: 【Rails】Ruby on Rails Tutorial 7章を読み終えて
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-17T16:03:06+09:00'
id: 123a707a70365dee4d63
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカで独学でエンジニアを目指している者です。
現在、Ruby on Rails Tutorialを使ってRailsを勉強しており、学んだことを忘れないように振り返りの記事を書いてみました。

開発環境
OS: Window11
Gemfile: Ruby on Rails Tutorialに書いてあるバージョンを使用
その他 : Doceker + vscodeを用いて開発

https://railstutorial.jp/help#devcontainer

# ユーザー登録
前回はユーザーの名前やメールアドレスについてのバリデーションを学習しました。今回はそれらを活用してサインアップページを作成し、テストを行うところまでがメインの内容です。

## ユーザーを表示する
まずは、Webサイトのレイアウトにデバッグ情報を表示させました。Railsは裏側で動いている処理が多く見えづらいので、デバッグ情報を明示的に表示し、理解を深めるのが狙いだと思われます。以下のように、`app/views/layouts/application.html.erb`にデバッグ用のコードを追加しました。

```html:application.html.erb
 <!DOCTYPEhtml>
<html>
  .
  .
  .
  <body>
    <%= render 'layouts/header' %>
    <div class="container">
      <%= yield %>
      <%= render 'layouts/footer' %>
      <%= debug(params) if Rails.env.development? %> <!--追加-->
    </div>
  </body>
</html>
```
`Rails.env.development?` は、Railsが開発環境(development)のときのみtrueとなります。Railsにはこのほかにも `test`、`production`(本番環境) が用意されています。
ここで引数に渡している `params` は、HTTPリクエストから受け取ったパラメータを扱うための変数です。詳しい仕様は今後改めて学ぶ予定です。

続いて、`routes.rb` において `users/:id` のルーティングが有効になっていなかったので、以下のコードを追記しました。
```ruby:routes.rb
Rails.application.routes.draw do
  root "static_pages#home"
  get "/help",
  to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  resources :users # 追加
end
```
`resources :users` を追加することで、RESTfulなUsersリソースで必要となるアクション（index, show, new, create, edit, update, destroy）にアクセスできるようになります。
RESTfulについては本格的に理解しようとするとややこしいですが、ひとまずは「これでユーザー関連の基本的なルーティングが一括で設定される」と理解しておけばOKです。


### debugger
ここでトラブルが発生しました。`debugger` メソッドを使おうとするとエラーが出てしまい、実行できなかったのです。
実は、`$ rails console` とGemfile内の
```ruby:Gemfile
group :development, :test do
  gem "debug", "1.7.1", platforms: %i[ mri mingw x64_mingw ] 
end
```
が干渉しており、毎回この行をコメントアウトしないと $ rails console が使用できませんでした。しかし、debugger を使うには上記のGemを有効化しておく必要があるため、コメントアウトするわけにもいかず、ChatGPTを使って解決策を模索しました。

エラーメッセージの一部に
```ruby
/usr/local/rvm/rubies/ruby-3.2.3/lib/ruby/gems/3.2.0/gems/debug-1.7.1/lib/debug/console.rb:25:in reset': missing keyword: :encoding (ArgumentError)
```
とあり、`console.rb`の中に 
```ruby
# reline 0.2.7 or later is required.
  raise LoadError if Reline::VERSION < '0.2.7'
```
という記述がありました。そこで以下のコマンドで現在のrelineバージョンを確認してみました。
```ruby
gem list reline
```
```ruby
# 実行結果

WARN: Unresolved or ambiguous specs during Gem::Specification.reset:
      stringio (>= 0)
      Available/installed versions of this gem:
      - 3.1.2
      - 3.0.4
WARN: Clearing out unresolved specs. Try 'gem cleanup <gem>'
Please report a bug if this causes problems.

*** LOCAL GEMS ***

reline (0.6.0, default: 0.3.2)
```
このあと、stringioのバージョンを3.1.2や3.0.4に変更して試しましたが効果はなく、最終的にGemfileに以下の記述を加えることで解決しました。
```ruby:Gemfile
gem 'reline', '~> 0.3.2'
```
これは「relineを0.3.2以上かつ0.4.0未満でインストールする」という意味です。実際に使用していたrelineのバージョン0.6.0は debug と互換性がなかったようで、バージョンを ~> 0.3.2 に固定したところ問題が解消しました。

### Gravatar 
Gravatarとは、メールアドレスと画像を紐づける無料のサービスです。サンプルアプリケーションではこれを使用して、プロフィール画像を表示しています。
`app/views/users/show.html.erb` でGravatarを呼び出し、その実装を `app/helpers/users_helper.rb` に書きました。

```html:show.html.erb
<% provide(:title, @user.name) %>
<h1>
  <%= gravatar_for @user %>
  <%= @user.name %>
</h1>
```

```ruby
module UsersHelper
  # 引数で与えられたユーザーのGravatar 画像を返す
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
```
ここではRuby標準ライブラリの Digest モジュールにある hexdigest メソッドを用いて、ユーザーのメールアドレスをMD5ハッシュ化し、その値を用いてGravatarのURLを生成しています。


## ユーザー登録フォーム
次に、他のユーザーがブラウザ上で新規登録できるようにフォームを作成しました。
まず、`app/controllers/users_controller.rb` の `def new` で `@user` を生成し、続いて `app/views/users/new.html.erb` にフォームのレイアウトを追加します。
```ruby:users_controller.rb
class UsersController <ApplicationController
  def show
    @user =User.find(params[:id])
  end
  def new
    @user =User.new # 追加
  end
end
```

```html:new.html.erb

<% provide(:title,'Signup') %>
<h1>Signup</h1>
<div class="row">
  <div class="col-md-6col-md-offset-3">
    <%= form_with(model:@user)do |f| %>
      <%= f.label :name %>　
      <%= f.text_field :name %>

      <%= f.label :email %>
      <%= f.email_field :email %>

      <%= f.label :password %>
      <%= f.password_field :password %>

      <%= f.label :password_confirmation, "Confirmation"%>
      <%= f.password_field :password_confirmation %>

      <%= f.submit "Createmyaccount", class: "btnbtn-primary"%>
    <% end %>
  </div>
</div>
```
`<% %>` の中にRubyの処理を書けるのは便利で、Railsの特徴の一つですね。
このフォームでは、名前・メールアドレス・パスワード・パスワード確認の入力欄を用意しています。`form_with`を呼び出すとRails内の`FormBuilder`がfというオブジェクトを生成し、これを使って手軽にフォーム要素を生成できるようになっています。

## ユーザー登録失敗

ここでは、Strong Parametersについて学びました。
以下のように、コントローラで `User.new(params[:id])` のようにparamsをまるごと渡してしまうと、ユーザーがリクエストに `admin: "1"` を仕込むだけで管理者権限を奪えてしまいます。
```ruby:users_controller.rb
def crate
@user = User.new(params[:id])
if @user.save
.
.
end
```
この問題を防ぐため、RailsではStrong Parametersという仕組みを使います。コントローラ内でparamsのうち許可したキーのみを受け取り、ホワイトリスト化された安全なデータだけをモデルに渡します。
```ruby:users_controller.rb
class UsersController <ApplicationController
  .
  .
  .
  def create
    @user =User.new(user_params)
    if @user.save
      #保存の成功をここで扱う。
    else
      render 'new',status::unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name,:email, :password, :password_confirmation)
    end
end
```
また、private メソッドにすることで、コントローラ外から user_params を直接呼び出せないようにしています。


# まとめ
7章あたりから難易度が上がってきたように感じます。
8章が終わったら、また1章から復習を始めようと思います。継続して取り組みながら、理解を深めていきたいです。


