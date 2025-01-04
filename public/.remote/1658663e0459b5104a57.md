---
title: 【Rails】Ruby on Rails Tutorial 5章を読み終えて
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-03T15:34:34+09:00'
id: 1658663e0459b5104a57
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカで独学でエンジニアを目指している者です。
現在、Ruby on Rails Tutorialを使ってRailsを勉強しており、学んだことを忘れないように振り返りの記事を書いてみました。
第5章は、これまでの章よりも内容が盛りだくさんでした。

# レイアウトを作成する
これまではRailsの内部について学習してきましたが、今回はBootstrapというフレームワークやCSSを中心に扱う章となっています。
## ナビゲーション

```html
<!DOCTYPE html>
<html>
  <head>
    <title><%= full_title(yield(:title)) %></title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta charset="utf-8">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body>
    <header class="navbar navbar-fixed-top navbar-inverse">
      <div class="container">
        <% link_to "sample app",'#', id: "logo" %>
        <nav>
          <ul class = "nav navbar-nav navbar-right">
            <li><%= link_to "Home", '#' %></li>
            <li><%= link_to "Help", '#' %></li>
            <li><%= link_to "Log in", '#' %></li>
          </ul>
        </nav>
      </div>
    </header>
    <div class="container">
      <%= yield %>
    </div>    
  </body>
</html>
```
この中でも
```html
<% link_to "sample app",'#', id: "logo" %>
```
については、Railsのヘルパーを用いてHTMLのアンカータグ(a)を作成するもので、以下のような意味があります。

- **第一引数**: リンクテキスト（ここをクリックすると第二引数のリンク先に飛ぶ）
- **第二引数**: URL（今回はダミーで # を指定）
- **第三引数**: オプションハッシュ（今回はCSSのid属性にlogoを指定）

### Bootstrapをインストール
Ruby on Railsでは、CSSをより簡単に書くためのツールがあると友人から聞いていましたが、おそらくそれがBootstrapのことだろうと思って進めました。
BootstrapではLESSというCSSメタ言語が使用されているようですが、RailsのデフォルトはSass言語を使う設定になっているようです。
また、Bootstrapを利用するとレスポンシブデザインを簡単に実装できるうえ、CSSを一から書くよりも手軽に“それっぽい”見た目が作れるので、とても感動しました。

### パーシャル
上記のヘッダー部分は少し長く散らかっているので、ビューにおいて再利用できる「パーシャル」という機能を使って整理していきます。
```html:application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title><%= full_title(yield(:title)) %></title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta charset="utf-8">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body>
    <%= render 'layouts/header' %>
    <div class="container">
      <%= yield %>
    </div>    
  </body>
</html>
```
これで、ヘッダーがだいぶすっきりしました。あとは、`app/views/layouts/_header.html.erb`を新規作成し、先ほどのヘッダー内容を移します。
```html:_header.html.erb
<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <% link_to "sample app",'#', id: "logo" %>
    <nav>
      <ul class = "nav navbar-nav navbar-right">
        <li><%= link_to "Home", '#' %></li>
        <li><%= link_to "Help", '#' %></li>
        <li><%= link_to "Log in", '#' %></li>
      </ul>
    </nav>
  </div>
</header>
```
同様に`app/views/layouts/_footer.html.erb`も作成し、`app/views/layouts/application.html.erb`にフッターを読み込むようにしましたが、ここで不具合が発生しました。
なんと、CSSが更新されなくなってしまったのです。

いろいろ調べた結果、以下の記事にたどり着きました。

https://qiita.com/scivola/items/e3e766b3e672a39b7a8f

どうやら、publicディレクトリ下に`assets`ディレクトリが生成され、キャッシュとして機能していたことが原因のようでした。
### RailsのURLからPath変更
今までのコードは下記のように書いていました。
```ruby:routes.rb 
Rails.application.routes.draw do 
  root "static_pages/home"
  get  "static_pages/home"
  get  "static_pages/help"
  get  "static_pages/about"
  get  "static_pages/contact"
end
```
しかし、`root_path` や `home_path` のように呼び出せるほうがコードの保守性が高いので、以下のように修正しました。
```ruby:routes.rb 
Rails.application.routes.draw do 
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
end
```
上記によって名前付きルーティングが使えるようになり、URLを直接指定する必要がなくなりました。テストやヘッダー、フッターも以下のように書き換えます
```ruby:static_pages_controller_test.rb
require "test_helper"
class StaticPagesControllerTest <ActionDispatch::IntegrationTest
  test "shouldgethome" do
    get root_path # ここを変更
    assert_response :success
    assert_select "title", "RubyonRailsTutorialSampleApp"
  end
  test "shouldgethelp" do
    get help_path # ここを変更
    assert_response :success
    assert_select "title", "Help| RubyonRailsTutorialSampleApp"
  end
  test "shouldgetabout" do
    get about_path # ここを変更
    assert_response :success
    assert_select "title", "About| RubyonRails TutorialSampleApp"
  end
  test "shouldgetcontact" do
    get contact_path # ここを変更
    assert_response :success
    assert_select "title", "Contact| Rubyon Rails TutorialSampleApp"
  end
end
```

# まとめ
前回よりも新たに学ぶ内容が多く、CSSが更新されないトラブルが発生した際は大変でしたが、何とか解決できてよかったです。
現在6章を読んでいるのでまたでき次第記事にしようと思います。
