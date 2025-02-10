---
title: 【Rails】route.rbのパスの指定方法
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-02-10T11:46:38+09:00'
id: 07687e1f0556e2764646
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカで独学でエンジニアを目指している者です。
現在 Rails を勉強中で、routes.rb のルーティングの指定方法について、忘れないうちにまとめておきたいと思い、この記事を書きました。

## ルーティングとは
Railsでは、ユーザーがアクセスしたURL（例: GET /help）をどのコントローラのどのアクションに結びつけるかを、`routes.rb` というファイルで定義します。典型的には以下のような記述を行います。
```ruby
Rails.application.routes.draw do
  get '/help', to: 'static_pages#help'
end
```

この場合、`"/help"` に GETリクエストが送られると、`StaticPagesController` の `help` アクションが実行されるという設定になります。

## 名前付きルートヘルパーについて
Railsは、ルーティングで定義したURLに応じて**名前付きルートヘルパー**というメソッドを自動生成します。例えば、上の例では以下のヘルパーメソッドが使えるようになります。

* `help_path` -> `"/help"`
* `help_url` -> `http://localhost:3000/help` (開発環境の場合)

Railsの慣習としては、ビューなどでリンクを貼る場合には `help_path` を使うことが多く、リダイレクトするときには `help_url` を用いることがあるようです。

## ルーティングの書き方
Railsチュートリアルでは2つのルーティングの書き方について習いました(8章まで)。
* `get '/help', to: 'static_pages#help'`(URL指定)
* `get 'static_pages/help'`

### `get '/help', to: 'static_pages#help'`(URL指定)
1. **URLがシンプル**
コントローラ名を表示しないので、`/help` のような短いURLになります。ユーザーにも覚えやすく、入力しやすいです。

2. **SEO（検索エンジン最適化）に良い**
シンプルなURLは検索エンジンにも好まれ、サイトの評価が上がる可能性があります。

3. **名前付きルートが自動生成される**
例えば '/help' を定義すると、`help_path`・`help_url` というシンプルな名前付きルートが生成されます。

### `get 'static_pages/help'`
1. コントローラとアクションの対応が明確
static_pages/help のように書くことで、「コントローラ名が static_pages でアクションが help なんだな」とひと目で分かります。

2. 小規模・学習用途で手軽に使える
開発の初期段階や学習目的であれば、特別にURLをカスタマイズしなくてもよいケースがあります。


## どちらのルーティングの書き方を使うべきか
Railsチュートリアルでも解説されていますが、上記の内容を踏まえると、`get '/help', to: 'static_pages#help'`（URL指定）の書き方を採用するのが一般的におすすめです。
ユーザーにとっては `/help` や `/about` のように短いURLのほうが理解しやすく、入力もしやすいでしょう。
また、`'static_pages#help'` は「StaticPages コントローラーの help アクションを使う」と明示的に指定しています。
一方、`get 'static_pages/help'` は URLからコントローラーとアクション名をRailsが推測しているため、誤ったルーティングが設定されるリスクがわずかにあるといわれています。

# まとめ
Railsのルーティングには、`get '/help', to: 'static_pages#help'` のようにURLを明示的に指定する方法と、`get 'static_pages/help'` のようにコントローラー名とアクション名をそのまま記述する方法があります。
どちらにも利点はありますが、一般的にはシンプルでわかりやすいURLを使用したほうがユーザーに親切であり、SEOの面でもメリットが大きいです。ぜひアプリケーションの目的に合わせて使い分けてみてください。
