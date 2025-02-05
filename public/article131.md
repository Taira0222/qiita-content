---
title: 【Rails】Bootstrapとは
tags:
  - Ruby
  - Railsチュートリアル
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: ''
id: null
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカで独学でエンジニアを目指している者です。
現在 Rails を勉強中ですが、初めて Bootstrap を触ったので、今回は教材に出てきた Bootstrap について記事にしてみたいと思います。

開発環境
ruby 3.2.3
rails 7.0.4.3
bootstrap-saass 3.4.1

# Bootstrapとは
Bootstrap は、Web ページや Web アプリケーションのデザインを簡単に整えるための CSS フレームワーク です。
HTML、CSS、JavaScript が組み合わさったツールキットで、レスポンシブデザインやモダンな UI を手軽に構築できる仕組みを提供します。
Rails では、Gemfile に `gem 'bootstrap-sass', '3.4.1'` のように記述して `bundle install` するだけで導入可能です。

## コード例
以下は、Bootstrap を使用しているコードの一例です。
現在学習している Rails チュートリアル から一部引用しています。

```html:application.html.erb
<!DOCTYPEhtml>
<html>
・
・
・
  <body>
    <header class="navbar navbar-fixed-top navbar-inverse">
      <div class="container">
      <%= link_to "sample app", '#', id:"logo"%>
        <nav>
        <ul class="nav navbar-nav navbar-right">
          <li><%= link_to "Home", '#' %></li>
          <li><%= link_to "Help", '#' %></li>
          <li><%= link_to "Login",'#' %></li>
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
CSS だけを学んでいた段階では、「なぜクラスが 3 つもあるの？1 つではダメなの？」と疑問に思いましたが、Bootstrap の場合は `navbar` や `navbar-fixed-top` をクラスに加えることで、あらかじめ用意されているスタイルが反映される 仕組みになっています。

### `header class="navbar navbar-fixed-top navbar-inverse"`
今回はBootstrapに焦点を当てて説明していきます。
* `navbar`: ナビゲーションバー（横並びのリンクメニュー）を作成するためのスタイルを提供します
* `navbar-fixed-top`: ヘッダーがスクロールしてもページの上部に固定されるスタイルを指定します。
* `navbar-inverse`: ナビゲーションバーの色を逆転（通常は背景が濃い色、文字が白）させます。

これらを `class` 属性に並べることで、上記 3 つの性質を同時に `header` に適用できます。

### `ul class="nav navbar-nav navbar-right"`
* `nav`: ナビゲーションリンクのリストであることを示します。
* `navbar-nav`: Bootstrapのクラスで、ナビゲーションバー内のリンクを整列させるスタイルを提供します。
* `navbar-right`: リンクを右寄せにするスタイルを適用します。

# まとめ
本日は Rails チュートリアルで登場した Bootstrap について紹介しました。
Rails でアプリを作成するにあたって、システムの仕組みだけでなく「見た目」も非常に重要です。そのため、デザインを整える一つの方法として Bootstrap を理解しておくと良いでしょう。

教材にはこのほかにも `jumbotron` や `bt`n などのクラスが登場しますが、今回は解説をここまでにしておきます。
Rails チュートリアルを 1 周目で学んでいたときは、クラスを複数書く理由を深く考えていませんでしたが、今回の学習を通じて「なぜクラスを 3 つ書いているのか？」がわかり、今後の学習でさらに理解が深まりそうです。

Bootstrapについてもう少し知りたい方は公式ドキュメント(日本語)があるようなので確認してみてください

https://getbootstrap.jp/docs/5.3/components/navs-tabs/