---
title: 【Ruby】メソッドとは
tags:
  - メソッド
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
というのも、現在progate→ゼロから分かるRuby→たのしいRubyと段階を追って勉強しているのですが、メソッドを深堀したり自分の中での定義を確立する機会がありませんでした
改めて時間をとってメソッドについてまとめていきたいと思います。

# メソッド
メソッドは、オブジェクトに対して行える処理や動作を定義するものです。
Rubyではメソッドはオブジェクトの動作を記述し、オブジェクトに対して呼び出すことができます。
Rubyのメソッドは、基本的に「メソッド名と引数を受け取って、特定の処理を行い、結果を返すもの」として機能します。
```ruby:method.rb
# メソッドの定義
def greet(name)
  "Hello, #{name}!"
end

# メソッドの呼び出し
puts greet("Alice")  # => "Hello, Alice!"
```
上記の例では、`greet`というメソッドが引数`name`を受け取り、それを使って挨拶文を生成して返しています。
ちなみに`Alice`を実引数、`greet(name)`の`name`を仮引数といいます。
これらの説明が聞きたい方はこちらの記事をどうぞ

https://qiita.com/Taira0222/items/3aca35ddbbf7c76cb6ae

上記のようなケース以外にもクラスとメソッドが関係する場合があるのでそれについても説明していきます

## クラスとメソッドの関係性
クラスで定義されるメソッドは大きく3種類あります。
* インスタンスメソッド
* クラスメソッド
* 関数メソッド

### インスタンスメソッド
```ruby:method2.rb
class Animal
  def initialize(name)
    @name = name  # インスタンス変数に名前を保存
  end
  
  def speak
    puts "#{@name} is making a sound!"
  end
end

# Animalクラスのインスタンスを生成
dog = Animal.new("Dog")
cat = Animal.new("Cat")

# インスタンスメソッドを呼び出す
dog.speak  # => Dog is making a sound!
cat.speak  # => Cat is making a sound!
```
`class`内のメソッドをインスタンスメソッドといい、下記でいうと`Animal`クラス内に定義された`initialize`や`speak`メソッドを指し、単なるメソッドと呼び出しの方法が異なります。
例えば、`dog.speak`という呼び出しで、`dog`インスタンスの`@name`変数を利用して「Dog is making a sound!」というメッセージが表示されます。
同様に、`cat.speak`で「Cat is making a sound!」となります。

ここで上記コードの理解度を深めるために補足説明ですが、`Animal`クラスでは、`initialize`という特殊なメソッドが定義されています。
`initialize`メソッドはクラスからインスタンスが生成されたときに自動的に呼び出されるメソッドで、インスタンスごとに固有のデータをセットするために使われます。
この場合、`@name`というインスタンス変数に`Dog`や`Cat`といった名前を保存しています。
このインスタンス変数`@name`は、そのインスタンスごとに異なる値を持つことができるため、異なる動作（`speak`メソッドで名前を使って出力される）をインスタンスごとに行うことが可能になります。

### クラスメソッド
続いて、2つめのクラスメソッドについて説明していきます
```ruby:class1.rb
class Animal
  def self.general_info
    puts "Animals are living creatures."
  end
end

# クラスメソッドを呼び出す
Animal.general_info  # => Animals are living creatures.
```
クラスメソッドはselfを使って定義され、インスタンスを生成する必要がありません。このメソッドはクラスそのものに対して呼び出されます。
インスタンスメソッドは`インスタンス.メソッド`でしたが、クラスメソッドの場合は`クラス.メソッド`であることとメソッドを定義する際に`self`を忘れずにつけましょう。

### 関数メソッド


