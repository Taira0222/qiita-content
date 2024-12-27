---
title: 【Rails】Ruby on rails Tutorial 7版 1~3章を読み終えて
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-27T14:22:43+09:00'
id: a94a33770e2f61d9bbf2
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカで独学でエンジニアを目指している者です。
現在、Ruby on Rails Tutorialを使ってRailsを勉強しており、学んだことを忘れないよう振り返りの記事を書いてみました。

## 1章 ゼロからデプロイまで
### Ruby on Railsの開発設定
Ruby on Railsを進めるうえで開発環境を以下の中から選ぶことができました
1. GitHub Codespace
2. VScode & Docker
以前、SQLを学ぶ際にMySQLをAWS EC2上で使っていましたが、`HTML/CSS/JavaScript/Ruby`などの作業をすべてVSCode上で進めることに慣れていたため、EC2での作業にやりにくさを感じました。
また、実際にアプリを作る際はDockerを使う予定だったので、ちょうどいいタイミングで導入できたと思っています。

### ファイル数すごい多い
まず最初に感じたのは、Railsで生成されるファイル数が非常に多いことです。そして、それぞれが重要な役割を果たしています。
```Ruby
$ cd 
$ rails _7.0.4.3_ new hello_app
```
これだけでたくさんのファイルが作られるので、「一体何が起きているんだろう？」と思いましたが、3章まで進むと少しずつ各ファイルの役割がわかってきました。

### GitHubにpush & Renderにデプロイ
GitHubへのpushは日常的にやっているのであまり驚きはなかったのですが、Renderを使ったデプロイは初めてで、とても簡単だったことに驚きました。
Webアプリケーションのデプロイはもう少し大変なイメージがあったのですが、ボタン一つでできてしまうとは…。
とはいえ、実際に自分でやるときはAWSを使う予定なので、もう少し大変になる気がしています。

### 1章のまとめ
1章は、「コマンドを打ったらすぐにアプリが生成されて、デプロイもできる」という流れで、とりあえず全体像をざっくり体験させる内容でした。
最初の章としては興味を引く役割を十分果たしていると思いますが、何が起きているかの詳細な説明があまりなかったので、「これから本格的に学んでいくぞ」という気持ちに切り替わりました。

同時に、「あれ？Rubyって実はそんなに書かないのでは？」とか「アウトプットする機会が意外と少ないかも？」など、ちょっと寂しい気持ちにもなりました。

## 2章 Toyアプリケーション
### Scaffold
Scaffoldは私にとって初めて聞くコマンドでしたが、Rails界隈では有名で、驚くほど簡単にブログサイトのようなものを作れます。
この章では、UsersとMicropostというリソースを作成し、そこから学習を進めました。

### 2章で学んだこと
この章で伝えたかったのは、「コードを通してMVCを理解する」という点だと思います。
著者いわく、Scaffoldは便利な反面、構造を深く理解するには難しいところもありますが、それでもMVCという枠組みが一気に見渡せるので、コード全体の流れをつかむにはとても良い章でした。
- `config/routes.rb`: クライアントからのリクエストが来たときにどのコントローラ・アクションで処理するかを決める、いわば「受け口」のような役割。
- `app/controllers/users_controller.rb`: routes.rbで指定されたアクションが呼び出されたときに、実際に何をするのかを決める（/users や /users/:id、/users/newなど）。
- `app/views/users/index.html.erb`: 実際の画面表示（サイトの見た目）に関する部分（ここでは /users）。
- models: `ActiveRecord::Base`などを継承しているため、細かい処理を書かなくてもDB操作などモデル固有の処理を行える。

## 3章 ほぼ静的なページの作成

### 自分でwebアプリを作っている感
2章ではScaffoldの力でサクッとアプリができてしまいましたが、3章では手を動かして「自分で作っている」という感覚を味わえました。
今回作った`Sample_app`では、まずStaticPagesコントローラを作成します。
```ruby
$ rails generate controller StaticPages home hello
```
その後、aboutアクションをテストしながら手動で追加していく流れになるので、テストの重要性も理解しやすかったです。
また、万が一コントローラ名を間違えて生成してしまったときは以下のように取り消すコマンドが用意されていることも知りました。
```ruby 
$ rails generate controller StaticPages home hollo # 間違えてholloにしてしまった
$ rails destory controller StaticPages home hollo
```

さらに、2章で学んだconfig/routes.rbが、get "`static_pages/home`"のように細かくルーティングできることがわかったので、routes.rbの全体像が少しずつ見えてきました。
```ruby:routes.rb
 Rails.application.routes.draw do
    get "static_pages/home"
    get "static_pages/help"
    root "application#hello"
 end
```
### テスト
この章から簡単なテストを実装し始めました。
テストのほうがコード本体よりシンプルな場合は、先にテストを書いたほうが効率的だそうで、今回も先にテストファイルを用意して進めています。
テストファイルは `test/controllers/static_pages_controller_test.rb` にあり、以下のようになっています。
```ruby
require "test_helper"
  class StaticPagesControllerTest < ActionDispatch::IntegrationTest
    test "should get home" do
      get static_pages_home_url
      assert_response :success
    end
    test "should get help" do
      get static_pages_help_url
      assert_response :success
    end
 end
 ```
 英語さえ読めればそこまで難しいことは書かれておらず、`assert_response :success` だけ少しピンと来ないかもしれませんが、HTTPレスポンスが200番台だとOKという意味です。
このようにテストを通してページを追加・修正しながら、3章ではほぼ静的なページを作成していきました。

# まとめ
思い出しながら書いたのでところどころ散らかった内容になってしまいましたが、今のところは著者の意図がわかりやすく、問題なく学習を進められています。
個人的には「もっとRubyらしいコードの部分を深く学びたいな」と思いつつ、Ruby on Rails Tutorialは9章から本格的に難しくなるとも聞いているので、これからもブログ形式でアウトプットしながら学びを深めていきたいと思います。
