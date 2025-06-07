---
title: 【rails】あるviewだけヘッダーやフッターを表示させない方法
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-06-07T12:11:43+09:00'
id: 8ce65302b3a69df27f1d
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails チュートリアルのアウトプットとしてアプリを製作しています。
認証周りは devise を使用しており、パスワード変更の view の実装をしていました。
普段は header・footer を書いているけど、この view の時は header・footer を表示させたくないみたいな場面って出てくるのではないでしょうか
今回はそんな場面で、view を切り替える方法について記事にしていきたいと思います。

## 手順

### 1. views/layouts に別途表示用の view ファイルと作成

```html
<!DOCTYPE html>
<html>
  <head>
    <title><%= content_for(:title) || "Todo Application" %></title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />
    <%= csrf_meta_tags %> <%= csp_meta_tag %> <%= yield :head %> <%# Enable PWA
    manifest for installable apps (make sure to enable in config/routes.rb too!)
    %> <%#= tag.link rel: "manifest", href: pwa_manifest_path(format: :json) %>

    <link rel="icon" href="/icon.png" type="image/png" />
    <link rel="icon" href="/icon.svg" type="image/svg+xml" />
    <link rel="apple-touch-icon" href="/icon.png" />

    <%# Includes all stylesheet files in app/assets/stylesheets %> <%=
    stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload"
    %> <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %> <%=
    javascript_importmap_tags %>
  </head>

  <body class="flex flex-col min-h-screen">
    <%= render 'shared/flash' %> <%# headerとfooterのみを削除した%>
    <main class="flex-grow"><%= yield %></main>
  </body>
</html>
```

上記のように `views/layouts/application.html.erb`からコピーし,header と footer のみを削除した`views/layouts/minimal.html.erb`を作成します。
minimal の部分は適宜変えて問題ありません

### 2. コントローラーに layout 'minimal'を記述

```ruby
class Users::PasswordsController < Devise::PasswordsController
  layout 'minimal', only: [:edit,:update]
  # GET /resource/password/new
  def new
    super
  end

    # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    super
  end
end
```

今回私は password リセットの際に`minimal`のテンプレートを適応させたかったので、上記のように書きました。
ここで、update も layout を minimal にしているのは、パスワードの変更でエラーになった場合その時に呼ばれているは update アクションなので設定していないとデフォルトの application.html.erb が呼ばれてしまいます。
