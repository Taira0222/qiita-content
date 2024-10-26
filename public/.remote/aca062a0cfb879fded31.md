---
title: 【Ruby】メソッドとは
tags:
  - Ruby
  - 初心者
  - メソッド
  - 未経験エンジニア
  - 未経験からWeb系
private: false
updated_at: '2024-10-26T08:09:22+09:00'
id: aca062a0cfb879fded31
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
また、メソッドは大きく3つの種類に分類されます。

* 関数メソッド
* インスタンスメソッド
* クラスメソッド

### 関数メソッド
Rubyでは、特定のクラスに属さないメソッドを定義することもできます。
これを関数メソッドと呼び、トップレベルで定義されたメソッドとして機能します。
つまり、オブジェクトやクラスに属するのではなく、どこからでも呼び出すことができるようなメソッドです。
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

### 補足
どうやら、クラスメソッドの場合は`self.general_info`と記載するのではなく以下のようにするのが一般的なようです
```ruby:compliment.rb
class Animal
  class << self
    def general_info
      puts "Animals are living creatures."
    end
    
    def common_traits
      puts "Animals need water and food to survive."
    end
  end
end
```
このように、`class << self`のブロック内にまとめると、複数のクラスメソッドが並ぶことを示しやすくなるため、読み手にとっても「この部分はクラスメソッドの定義である」と直感的に理解しやすくなります。
また、クラスメソッドが変更しやすかったり(メンテナンス性向上),可読性の観点からこの方法が好まれるようです。

# まとめ
この記事では、Rubyのメソッドについて基本的な知識を整理しました。
メソッドはオブジェクトの動作を定義する重要な要素であり、Rubyでは以下の3つに分類されます。

* 関数メソッド
クラスに属さず、トップレベルで定義されるメソッド。
* インスタンスメソッド
クラス内で定義され、特定のインスタンスに対して動作するメソッド。
* クラスメソッド
クラス自体に対して定義され、インスタンスを生成せずに利用できるメソッド。
