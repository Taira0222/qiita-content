---
title: 【Rails】form_withのhidden_field_tag と f.hidden_field
tags:
  - Ruby
  - Rails
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-30T12:04:05+09:00'
id: 3667235eb79b3c0de704
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカに住みながら独学でエンジニアを目指しているTairaです。

Railsでフォームを作成するとき、隠しフィールドを設定する方法として`hidden_field_tag`と`f.hidden_field`があります。それぞれの違いを具体的に理解しましょう。

### 1. hidden_field_tagとは
`hidden_field_tag` はフォームに関連付けられたモデルとは独立したパラメータを送信するときに使います。フォームオブジェクトとは無関係な単純なパラメータを設定したいときに最適です。

```erb
<%= hidden_field_tag :email, @user.email %>
```

フォーム送信後、パラメータは以下のように受け取れます。

```ruby
params[:email] #=> user@example.com
```

### 2. f.hidden_fieldとは
一方、`f.hidden_field`はフォームが持つモデルの属性として値を送信するときに使います。

```erb
<%= form_with(model: @user) do |f| %>
  <%= f.hidden_field :email, value: @user.email %>
<% end %>
```

フォーム送信後、パラメータは以下のようになります。

```ruby
params[:user][:email] #=> user@example.com
```

### 3. どちらを使うべき？

- **hidden_field_tagが適している場合**
  - モデルとは関係ない一時的なパラメータ（認証用トークン、確認用情報など）を送りたいとき。
  - 明示的にモデル属性とは分離して、フォーム処理を明確化したいとき。

- **f.hidden_fieldが適している場合**
  - モデルの属性を更新または作成する際に、フォーム入力欄では表示せずに内部的に値をセットしておきたいとき。

### まとめ
- `hidden_field_tag`はフォームモデルと無関係にトップレベルのパラメータをセット。
- `f.hidden_field`はフォームのモデル属性として値をセット。



