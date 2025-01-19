---
title: 【Rails】Ruby on Rails Tutorial 4章を読み終えて
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-31T14:05:51+09:00'
id: 7ebe74cbf1d2b42d3653
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカで独学でエンジニアを目指している者です。
現在、Ruby on Rails Tutorialを使ってRailsを勉強しており、第4章まで読み終えたので、学んだことを忘れないように振り返りの記事を書いてみました。

# Rails風味のRuby
このタイトルを見て「やっとRubyを使うチャンスがきた」と期待していましたが、RailsでRubyがどのように動作するかというよりは、Rubyの文法の説明やRailsファイルの理解を助ける内容でした。とても親切な内容です。
習った内容は以下の通りです：
* ヘルパー
* Ruby の文法
* クラスの継承
それぞれについて見ていきますが、クラスの継承については新しいことや再学習することがあまりなかったため、2つに絞って解説します。

## ヘルパー
個人的には一番学びが多かった部分でした。
ヘルパー（helper）はその名前が示す通り、主にビューで使用する補助的なメソッドを定義するために使用されます。
`app/views/layouts/application.html.erb`上で、同じコードを繰り返したくない（DRY原則）場合に利用します。
`app/helpers/application_helper.rb`でメソッドを定義することで、`app/views/layouts/application.html.erb`上でそのメソッドを使用できるようになります。

```ruby:app/views/layouts/appkication.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App </title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta charset="utf-8">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```
上記のコードは、変更前のファイルです。`title`は各アクションのHTMLファイルごとに設定され、そのタイトルを読み込むという仕組みですが、最初の画面（今回はHome）でも`Home | Ruby on Rails Tutorial Sample App`というタイトルが表示されるのは煩わしいと感じました。
そこで、Home画面では`Ruby on Rails Tutorial Sample App`というタイトルのみを表示するようにコードを修正しました。

1. `app/helpers/application_helper.rb`で`full_title`メソッドを定義する
2. `app/views/layouts/application.html.erb`に1で定義したメソッドを組み込む
3. `app/views/static_pages/home.html.erb`の不要な部分を削除する

### 1. `app/helpers/application.helper.rb`で`full_title`メソッドを定義する
```ruby
module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
```
`ApplicationHelper`モジュールは最初から存在しているので、その中に新しくメソッドを追加します。
上記のコードの詳細な説明は本書で丁寧に行われているため、ここでは割愛します。

### 2.`app/views/layouts/application.html.erb`に1で定義したメソッドを組み込む
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
    <%= yield %>
  </body>
</html>
```
後で出てきますが、`app/views/static_pages/home.html.erb`の`<% provide(:title, "Home") %>`が上記コードの`:title`に代入されています

### 3. `app/views/static_pages/home.html.erb`の不要な部分を消す
今回はHomeのタイトルを`Ruby on Rails Tutorial Sample App`にするので以下のように変更しました。
変更前
```html
<% provide(:title, "Home") %>
<h1>Sample App</h1>
<p>
    This is the home page for the
    <a href="https://railstutorial.jp">Ruby on Rails Tutorial</a>
    sample application.
</p>


```
変更後
```html
<!-- ここの1行を削除しました -->
<h1>Sample App</h1>
<p>
    This is the home page for the
    <a href="https://railstutorial.jp">Ruby on Rails Tutorial</a>
    sample application.
</p>

```
変更前では`provide(:title, "Home")`によってタイトル名（Home）を設定していましたが、変更後はタイトルを設定しないことで、`full_title`メソッド内の条件に該当し、`Ruby on Rails Tutorial Sample App`が表示されるようになります。
```ruby
module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
~~~~~~~~~~~~~~~~
end
```

## Ruby の文法
この部分については、ほぼ知識があったため流し読みし、理解が不十分だった箇所をピックアップして学習しました。以下に、いくつか補足したポイントをまとめます。
- returnの必要性について
私が苦手としているreturnについても取り上げられており、理解が深まりました。例えば、以下の例を見てみましょう。
```ruby
def string_message(str = "")
  if str.empty?
    "It's an empty string!"
  else
    "The string is nonempty."
  end
end
```

この場合、if文によって条件に応じて適切な文字列が返されます。一方、以下のように後置ifを使用することもできます。
```ruby
def string_message(str = "")
  return "It's an empty string!" if str.empty?
  return "The string is nonempty."
end
```
このコードでは、2つ目の`return`は1つ目の`return`に合わせるためにつけています。
1つ目の`return`がなぜ必要かというと、`string_message`メソッドの返り値は最後に評価された式になるため、`str.empty?`が真であっても2つ目の`return`が実行されてしまいます。そこで、1つ目の`return`を使用して早期にメソッドを終了させています。

- selfとは
`self` も苦手意識があるのですがこれも出てきました。
```ruby 
class Word < String
  def palindrome?
    self == self.reverse
  end
end

s = Word.new("level")
s.palidndrome? #=>true
```
上記のコードでの`self`とは何か疑問に感じました。調べてみると、`self`は**インスタンスメソッド内ではそのメソッドを呼び出しているオブジェクト自身**を指します。
具体的には、この場合selfは**Wordクラスのインスタンス'level'**を指しています。


# まとめ
Ruby on Rails Tutorialの第4章までを読み進めることで、新たに学んだヘルパーの役割や、理解が不十分だったreturnやselfについて理解を深めることができました。Ruby on Rails Tutorialは実践的な内容が多く、理解度を高めやすい一方で、頭の中を整理しないと学んだことを忘れてしまいそうです。次は第5章を読み終えたら、同様に振り返りの記事を書きたいと思います。
