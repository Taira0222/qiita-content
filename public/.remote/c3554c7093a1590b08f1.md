---
title: 【Ruby】スコープについて
tags:
  - Ruby
  - 初心者
  - ローカル変数
  - スコープ
  - 未経験エンジニア
private: false
updated_at: '2024-10-31T13:50:18+09:00'
id: c3554c7093a1590b08f1
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは、現在アメリカの大学で語学を学びながらソフトウェアエンジニアになるために独学で勉強しているものです。
今回は、Rubyのスコープについて整理した内容を共有します。
スコープは少し苦手意識があって避けていたのですが、しっかり向き合い、記事にまとめてみました。
もし内容に誤りがあればご指摘いただけると幸いです。

# スコープとは？
プログラム内の変数やメソッドには、それぞれアクセス可能な範囲が決まっています。
この範囲のことをスコープと呼び、変数の種類によって異なるスコープが適用されます。
この記事では、Rubyの代表的な変数のスコープについて、それぞれの用途やアクセス範囲を解説します。

## ローカル変数
ローカル変数は、メソッドやブロック内で定義され、その内部でのみ使用できます。
他の部分からアクセスや変更ができないため、安全に使えるのが特徴です。
```ruby:local1.rb
def greet
  message = "Hello, World!"
  puts message
end

greet  # => "Hello, World!"
puts message  # エラー: `message`は未定義
```
`message`変数は`greet`メソッドの中でのみアクセス可能で、メソッドの外ではエラーが発生します。

```ruby:local2.rb
name = "Alice"

def say_hello
  name = "Bob"
  puts "Hello, #{name}!"
end

say_hello  # => "Hello, Bob!"
puts name  # => "Alice"
```
上記の例では、`say_hello`メソッド内の`name`はメソッド内で新たに定義されたローカル変数であり、外の`name`変数には影響を与えません。

## グローバル変数
グローバル変数は、プログラム全体でアクセス可能な変数で、$を変数名の前につけることで定義されます。
全てのクラスやメソッドから参照・変更できるため便利ですが、予期せぬ影響が出やすいためあまり使われないとされています。
```ruby:global_variable.rb
$global_variable = "I'm accessible everywhere!"

def display_global
  puts $global_variable
end

display_global  # => "I'm accessible everywhere!"
puts $global_variable  # => "I'm accessible everywhere!"
```

## インスタンス変数のスコープ 
インスタンス変数は、特定のインスタンスに対して有効なスコープを持ち、異なるインスタンス間で共有されません。
`@`を変数名の前に付けることで定義され、外部から直接アクセスすることはできませんが、`attr_reader`や`attr_accessor`でゲッターやセッターを定義することで、外部から値を取得・設定することが可能です。
```ruby:instance.rb
class User
  def initialize(name)
    @name = name
  end

  def show_name
    puts @name
  end
end

user1 = User.new("Alice")
user2 = User.new("Bob")

user1.show_name  # => "Alice"
user2.show_name  # => "Bob"
```
この例では、`user1`と`user2`でそれぞれ異なるインスタンス変数`@name`を持ち、異なる状態を保持しています。
## クラス変数のスコープ
クラス変数は、クラス全体で共有されるスコープを持ち、`@@`を変数名の前につけて定義します。
クラスとその全インスタンス間で情報を共有するために使用されますが、クラスの継承時には予期せぬ動作をすることがあるため注意が必要です。
```ruby:class.rb
class Product
  @@count = 0

  def initialize(name)
    @name = name
    @@count += 1
  end

  def self.total_count
    @@count
  end
end

p1 = Product.new("Laptop")
p2 = Product.new("Phone")

puts Product.total_count  # => 2
```
上記の例では、`@@count`はすべてのインスタンスで共有され、インスタンスが生成されるたびに増加します。
また、クラス変数に対しては`attr_reader`や`attr_accessor`は使用できないため、`total_count`のようにクラスメソッドで参照する必要があります。

# まとめ
上記のまとめです。
* ローカル変数: メソッドやブロック内でのみ使用。外部に影響を与えないため、安全。
* グローバル変数: プログラム全体でアクセス可能。便利だが、予期しない影響が出やすい。基本的には使われない。
* インスタンス変数: 各インスタンスに固有で、異なるインスタンス間で共有されない。`attr_reader`などで外部からのアクセスを調整。
* クラス変数: クラス全体で共有され、全インスタンスで共通のデータを持つ場合に使用。継承時の動作には注意が必要。
