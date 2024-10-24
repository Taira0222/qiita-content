---
title: 【Ruby】レシーバとは
tags:
  - レシーバ
  - Ruby
  - 未経験からWeb系
  - 初心者
  - 未経験エンジニア
private: false
updated_at: ''
id: null
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは、現在アメリカの大学に行って語学を学びながらソフトウェアエンジニアになるために独学で勉強しているものです。
本日はRubyを勉強しているとよく出てくる、メソッドについて整理していきます。
というのも、現在progate→ゼロから分かるRuby→たのしいRubyと段階を追って勉強しているのですが、レシーバについて詳しく触れる機会がなく何となくでここまで進んでしまっているので
`rails`に入る前に定義をしっかり確立していきたいと思います。

# レシーバ
レシーバは、メソッドが呼び出される対象のオブジェクトです。
メソッドは、必ず何かしらのオブジェクトに対して呼び出され、呼び出されたオブジェクトがレシーバとなります。
レシーバは、メソッドが実行されるオブジェクトとも言えます。
```ruby:receiver1.rb
str = "hello"   # str は String クラスのオブジェクト
str.upcase      # str がレシーバとなり、upcase メソッドが呼ばれる
```
ここでは、`hello`というStringオブジェクトが`upcase`メソッドを呼び出しています。
この場合、`str`がレシーバです。メソッドがレシーバに対して何らかの操作を行い、その結果が返されます。

では続いて、`self`というレシーバについて説明していきたいと思います。
`self`はRubyの特別なキーワードで、<strong>現在のレシーバ（メソッドを呼び出しているオブジェクト）</strong>を指します。
`self`は現在のレシーバ（メソッドを呼び出しているオブジェクト）であるということと省略できる場合があります。
できない場合も後で説明するのでまずはこの2つを覚えておいてください。
まずは省略できるケースから紹介します

### selfが省略できるケース
```ruby:self1.rb
class Person
  def greet
    puts "Hello!"
  end

  def welcome
    greet  # ここでのgreetはself.greetと同じ意味
  end
end

person = Person.new
person.welcome  # => "Hello!"
```
この例では、`welcome`メソッド内で`greet`メソッドを呼び出していますが、`greet`の前に何もレシーバを書いていません。
先ほど`self`は現在のレシーバ（メソッドを呼び出しているオブジェクト）であると言っていたのに、、と思うかもしれませんが一回説明を聞いてくださいw
`greet`はインスタンスメソッドであり、これを呼び出すためには`person.greet`と呼び出す必要があります。
それはwelcomeの中でもそうなのですが、この場合は現在のレシーバ（メソッドを呼び出しているオブジェクト）である`self`を使用します。
英語でいう代名詞みたいなもので、例えば「Mike is kind. Mike has two brothers」とは言わずに「Mike is kind. He has two brothers」といいますよね。
Mikeという人の名前を繰り返し避けるためにHeを使用していますが、`self`も`person`インスタンスを置き換えているという点では似ています

では話を戻します。Rubyは暗黙的に`person.greet`を`self.greet`と解釈してくれます。
この場合、`self`はPersonクラスのインスタンスである`person`を指しています。
つまり、greetメソッドを呼び出しているのは`self`、つまり`person`というオブジェクトです。

### selfが省略できないケース
```ruby:self2.rb
class MyClass
  def self.greet
    "Hello from the class!"
  end
  def sit
    "Everyone sits down"
  end
end
myclass = MyClass.new
puts MyClass.greet  # => "Hello from the class!"
```
この例では、`greet`メソッドを`self.greet`と定義しています。
これにより、`greet`はクラスメソッドになり、`MyClass`というクラス自身に対して呼び出すことができます。
この場合、`greet`の前に`self`を置かないとエラーになります。なぜでしょうか。

クラスメソッドでは、selfがそのクラス自体を指しています。
クラスメソッドを定義する際にselfを使うことで、そのメソッドがクラスのインスタンスではなく、クラス自体に属していることを明確にします。これが、selfを使わなければならない理由です。

関係性
上記の説明に関連して、selfが現在のレシーバ（オブジェクトやクラスそのもの）を表しているという点が大事です。
クラスメソッドではレシーバがクラスそのものなので、selfを使って「このメソッドはクラス自体に定義されているものだ」と明示する必要があります。