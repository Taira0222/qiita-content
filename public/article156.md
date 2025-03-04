---
title: 【勉強記録】Qiita自動投稿＆X自動ポストシステムをGitHub Actionsを使って再現してみた part3
tags:
  - Ruby
  - 初心者
  - 未経験エンジニア
  - 独学
  - GitHubActions
private: false
updated_at: '2025-03-04T11:52:41+09:00'
id: 9766a095785a467367b0
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。私はアメリカ在住で、独学を通してエンジニアを目指している者です。
以前のPart2では、実際に使用したYAMLファイルと、QiitaおよびGitHubへpushするスクリプトについて解説しました。
本記事では、X（旧Twitter）への自動投稿について詳しく解説します。

---

## 今回使用したYAMLファイル

今回使用したYAMLファイルは以下の通りです。\
（※一部のジョブは省略してあります。）

```yml
name: Publish Article and Post to X

on:
  schedule:
    - cron: '0 2 * * *'  # 毎日UTC 02:00（Americaでは19:00に相当）に実行
  workflow_dispatch:

jobs:
  ・
  ・
  ・
      - name: Upload Published URL Artifact
        uses: actions/upload-artifact@v4
        with:
          name: published-url
          path: qiita-content/published_url.txt

      - name: Upload Published Title Artifact
        uses: actions/upload-artifact@v4
        with:
          name: published-title
          path: qiita-content/published_title.txt

  post_to_x:
    needs: publish
    runs-on: ubuntu-latest
    steps:
      - name: Checkout current repository
        uses: actions/checkout@v3
        
      - name: Download Published URL Artifact
        uses: actions/download-artifact@v4
        with:
          name: published-url
          path: published

      - name: Download Published Title Artifact
        uses: actions/download-artifact@v4
        with:
          name: published-title
          path: published_title

      - name: Read Published URL
        id: read_url
        run: |
          published_url=$(cat published/published_url.txt)
          echo "Published URL is: $published_url"
          echo "published_url=$published_url" >> $GITHUB_OUTPUT

      - name: Read Published Title
        id: read_title
        run: |
          title=$(head -n 1 published_title/published_title.txt)
          echo "Extracted title: $title"
          echo "title<<EOF" >> "$GITHUB_OUTPUT"
          echo "$title" >> "$GITHUB_OUTPUT"
          echo "EOF" >> "$GITHUB_OUTPUT"        

      - name: Set up Ruby for X API posting
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3.5'
        
      - name: Install x-ruby gem
        run: gem install x

      - name: Post tweet using x-ruby
        env:
          TWITTER_CONSUMER_KEY: ${{ secrets.TWITTER_CONSUMER_KEY }}
          TWITTER_CONSUMER_SECRET: ${{ secrets.TWITTER_CONSUMER_SECRET }}
          TWITTER_ACCESS_TOKEN_KEY: ${{ secrets.TWITTER_ACCESS_TOKEN_KEY }}
          TWITTER_ACCESS_TOKEN_SECRET: ${{ secrets.TWITTER_ACCESS_TOKEN_SECRET }}
          TWEET_TITLE: ${{ steps.read_title.outputs.title }}
          TWEET_URL: ${{ steps.read_url.outputs.published_url }}
        run: ruby scripts/post_x.rb
        shell: bash
```

---

## publish ジョブについて

publishジョブのコードは一部を省略し、今回のXへの自動投稿で必要な情報だけを残しています。

- **Upload Published URL Artifact**\
  Qiitaに投稿した際に生成されるハッシュ値を用いて記事のURLを生成し、`qiita-content/published_url.txt`に保存します。

- **Upload Published Title Artifact**\
  記事のタイトルを抽出し、`qiita-content/published_title.txt`に保存します。

これらのアーティファクトを活用することで、publishジョブから必要な情報（記事のURLとタイトル）を取得できるようにしています。

---

## post\_to\_x ジョブ

post\_to\_xジョブでは、XのAPIを利用して自動で投稿するための処理を行っています。\
このジョブで注意すべき点は以下の2点です。

- **x‑rubyというgemを使用してXのAPIを利用する**\
  Gemを利用することで、Xへの自動投稿スクリプトを簡単に作成できます。詳しくは以下のリンクをご参照ください。\
  [https://sferik.github.io/x-ruby/](https://sferik.github.io/x-ruby/)

- **X Developerへの登録とTokenの取得が必要**\
  XのAPIを利用するためには、X Developerに登録して以下の認証情報を取得する必要があります。

  - Consumer API Key
  - Consumer API Secret
  - Access Token
  - Access Token Secret

  これらのトークンは、GitHubリポジトリのSecretsに登録してください。手順は以下の通りです。

  1. GitHub Actionsを実行するリポジトリにアクセス
  2. 「Settings」を開き、左側の「Secrets and variables」から「Actions」を選択
  3. 「New repository secret」をクリックして、各トークンを登録

---

## 使用したスクリプト

以下は、実際にXへ投稿するために使用したRubyスクリプトです。

```ruby
#!/usr/bin/env ruby
require "x"
require "json"

# 環境変数から x‑ruby 用の認証情報を取得
x_credentials = {
  api_key:             ENV['TWITTER_CONSUMER_KEY'],
  api_key_secret:      ENV['TWITTER_CONSUMER_SECRET'],
  access_token:        ENV['TWITTER_ACCESS_TOKEN_KEY'],
  access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
}

# クライアントの初期化
x_client = X::Client.new(**x_credentials)

# ツイート本文の組み立て
tweet_text = "#{ENV['TWEET_TITLE']} #{ENV['TWEET_URL']}\n#Qiita\n#未経験エンジニア\n#駆け出しエンジニア"

# ツイート投稿（JSON形式の文字列を渡す）
payload = { text: tweet_text }.to_json
post = x_client.post("tweets", payload)

puts "Tweet posted successfully!"
puts "Tweet URL: https://twitter.com/i/web/status/#{post["data"]["id"]}"
```

---

## 使用したスクリプトの解説

このRubyスクリプトは、x‑rubyというGemを利用してXのAPIに接続し、ツイートを自動投稿するためのものです。以下に、各部分の解説を示します。

- **シバン行とライブラリの読み込み**

  ```ruby
  #!/usr/bin/env ruby
  require "x"
  require "json"
  ```

  シバン行は、このスクリプトがRubyで実行されることを示します。`x`ライブラリはXのAPIを操作するために、`json`ライブラリはツイート内容をJSON形式に変換するために読み込んでいます。

- **認証情報の取得**

  ```ruby
  x_credentials = {
    api_key:             ENV['TWITTER_CONSUMER_KEY'],
    api_key_secret:      ENV['TWITTER_CONSUMER_SECRET'],
    access_token:        ENV['TWITTER_ACCESS_TOKEN_KEY'],
    access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
  }
  ```

  環境変数から各種認証情報（Consumer API Key、Consumer API Secret、Access Token、Access Token Secret）を取得し、`x_credentials`というハッシュにまとめています。これらの値はGitHubのSecretsに設定されています。

- **クライアントの初期化**

  ```ruby
  x_client = X::Client.new(**x_credentials)
  ```

  `x_credentials`を展開してXクライアントを初期化し、APIに接続する準備を行います。

- **ツイート内容の作成**

  ```ruby
  tweet_text = "#{ENV['TWEET_TITLE']} #{ENV['TWEET_URL']}\n#Qiita\n#未経験エンジニア\n#駆け出しエンジニア"
  ```

  環境変数から取得した記事のタイトルとURLを使い、ツイート本文を組み立てています。改行コードでハッシュタグを追加し、投稿内容に補足情報を付与しています。

- **JSON形式への変換と投稿**

  ```ruby
  payload = { text: tweet_text }.to_json
  post = x_client.post("tweets", payload)
  ```

  ツイートの本文をハッシュとして定義し、`to_json`でJSON文字列に変換します。その後、`x_client.post`メソッドを呼び出してツイートを投稿し、結果を`post`に格納します。

- **投稿結果の出力**

  ```ruby
  puts "Tweet posted successfully!"
  puts "Tweet URL: https://twitter.com/i/web/status/#{post["data"]["id"]}"
  ```

  ツイートが正常に投稿されたことを確認するメッセージと、返却されたツイートのIDを用いて作成したツイートURLを出力しています。

このスクリプトにより、GitHub Actions上で取得した記事のタイトルとURLを元に、Xへ自動投稿が実現されます。

---

## まとめ

本記事では、Qiitaに記事を投稿した際に生成される情報（記事URLとタイトル）を利用して、GitHub Actions経由でXへ自動投稿する仕組みについて解説しました。\
YAMLファイルの設定、publishジョブでのアーティファクト生成、post\_to\_xジョブでの情報取得とX APIを利用した自動投稿の流れ、さらにx‑ruby gemの導入とX Developer登録の手順について、具体的なコード例を交えて説明しました。\
また、使用したRubyスクリプトについても、各行の役割や処理内容を詳細に解説することで、どのように認証情報を扱い、ツイート内容を組み立てて投稿しているのかを明確にしました。

この仕組みを活用することで、記事投稿から自動的にX上で情報発信が可能になり、エンジニアとしての活動の幅を広げることになると思います



