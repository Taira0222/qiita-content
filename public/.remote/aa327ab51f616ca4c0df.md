---
title: 【rails】turbo-frame
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - Hotwire
private: false
updated_at: '2025-06-09T12:20:38+09:00'
id: aa327ab51f616ca4c0df
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails チュートリアルのアウトプットとしてアプリを製作しています。
そのアプリの中でもSPAのような動きを取り入れる際に`turbo-frame` や`turbo-stream`(私のアプリではこちらをメインで採用)する必要がありました。
本日は`turbo-frame`について記事を書いていこうと思います。


## turbo-frame とは

Rails 7以降では、Hotwire（特にturbo）が標準で導入されています。
その中でも `turbo-frame` は、画面の一部だけを部分的に更新できる仕組みです。

ページ全体をリロードせず、一つの枠だけを差し替えるような動作が、JavaScriptなしで実現できます。

## turbo Frameの基本構文

```erb
<turbo-frame id="profile_frame">
  <!-- この中身だけが部分更新の対象になる -->
</turbo-frame>
```

ポイントは `id` 属性です。
サーバーからのレスポンスで、同じIDの `<turbo-frame>` を返せば、その中身が自動で差し替わります。

## 実践：プロフィール表示・編集の切り替え

### 1. show画面でプロフィール表示

```erb
<!-- app/views/users/show.html.erb -->
<turbo-frame id="user_profile">
  <%= render "profile", user: @user %>
</turbo-frame>
```

部分テンプレート `_profile.html.erb` には編集リンクも含めておきます。

```erb
<!-- app/views/users/_profile.html.erb -->
<p><%= user.name %></p>
<p><%= user.email %></p>

<%= link_to "編集", edit_user_path(user), data: { turbo_frame: "user_profile" } %>
```


* `link_to` に `data: { turbo_frame: "user_profile" }` を付けることで、
  そのリンクの遷移先（`users#edit`）のレスポンスを「user\_profile」フレーム内だけに差し替えます。

### 2. 編集画面（edit）

```erb
<!-- app/views/users/edit.html.erb -->
<turbo-frame id="user_profile">
  <%= render "form", user: @user %>
</turbo-frame>
```

`_form.html.erb` の中身は通常の `form_with` を使ってOKです。

```erb
<!-- app/views/users/_form.html.erb -->
<%= form_with model: user do |f| %>
  <%= f.text_field :name %>
  <%= f.email_field :email %>
  <%= f.submit "更新" %>
<% end %>
```

### 3. 更新後の挙動（update）

```ruby
# app/controllers/users_controller.rb
def update
  @user = User.find(params[:id])
  if @user.update(user_params)
    render partial: "profile", locals: { user: @user }
  else
    render partial: "form", locals: { user: @user }, status: :unprocessable_entity
  end
end
```

#### 解説

* フォーム送信後、成功時は `_profile.html.erb` を返すことで表示画面に戻る。
* turbo Frameが自動で `id="user_profile"` の中身を入れ替えてくれる。

## turbo Frameを使うメリット

| メリット         | 説明                 |
| ------------ | ------------------ |
| JavaScript不要 | JSを書かずにSPA的なUIが作れる |
| ページ遷移なし      | 一部だけの差し替えなのでUXが滑らか |
| URL履歴が残る     | ブラウザの戻る/進むが自然に使える  |

## turbo Frameが不要なケース

一方、次のようなケースでは `turbo-frame` は使わず、Turbo Stream（`turbo_stream.replace`など）で実装するほうが適しています。

* 複数箇所を同時に差し替えたい
* WebSocket（ActionCable）による配信を行いたい
* 明示的に `append` や `remove` を使いたい

その場合は `turbo-stream` を選びましょう。

## まとめ

* `turbo-frame` は、一部分だけを差し替えるシンプルな部分更新に最適
* `id`を持つ`turbo-frame`の中にリンクやフォームを置くだけで、Railsが自動で処理
* 複雑な更新には `turbo-stream` を使い分ける
