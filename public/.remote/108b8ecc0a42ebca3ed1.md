---
title: 【Ruby】モジュールの使い方
tags:
  - Ruby
  - 初心者
  - module
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-10T15:34:39+09:00'
id: 108b8ecc0a42ebca3ed1
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指しているものです。
以前継承とモジュールについて記事を書いたのですが、moduleの演習問題を解いた際に手が止まってしまったので、今回はmoduleとinclude,extend,prependについてみていきたいと思います

## Rubyにおけるmoduleとは
Rubyの module は、複数のクラスで再利用したいメソッドや定数をまとめて定義する仕組みです。
モジュールをそのまま “new” してインスタンスを作ることはできませんが、“ミックスイン” という形でクラスに取り込むことで、クラスに新たな振る舞いを追加することができます。

### モジュールの主な役割
1. 名前空間を提供する
クラスやメソッドの名前衝突を避けるためのスコープとして利用できる。

2. 共通メソッドの再利用
何度も書かれる同様のメソッドをまとめ、複数のクラスに取り込みやすくする（ミックスイン）。


## ミックスインと継承チェーン
Rubyでは、クラスとスーパークラス（親クラス）の関係が“継承チェーン”を形成します。しかし、モジュールをミックスインすると、この継承チェーンの途中にモジュールが挿入されてメソッド探索のルート（lookup chain）に変化が起こります。


### メソッド探索の基本（クラス継承のみ）
通常、クラスからメソッドを呼び出すときは、以下の順番でメソッドが探索されます。

1. レシーバとなるインスタンスのクラス
2. スーパークラス
3. さらにそのスーパークラス…
4. Object クラス
5. Kernel モジュール
6. BasicObject クラス
このルートの間にモジュールを挿入できるのが、include / extend(特異メソッド) / prepend となります。

## include
includeはモジュールのインスタンスメソッドを、クラスのインスタンスメソッドとして取り込む役割があります。
改めて知識の整理をするまではmoduleとはincludeという印象が強かったです

include したモジュールは、**現在のクラスのスーパークラスの手前** に挿入されます。
```ruby
module Greet
  def say_hello
    puts "Hello!"
  end
end

class Person
  include Greet
end

person = Person.new
person.say_hello  # => "Hello!"
```
継承関係(一例)
```ruby
person.ancestors #=>[MyClass,ModuleName,SuperClass,Object ...]
```

この呼び出しの際、Person のクラスを見て say_hello が定義されていない場合、
次に Greet モジュール内を探索 → 見つかったら実行というフローになります。

## extend
モジュールのインスタンスメソッドを、特異メソッド（クラスメソッド）として取り込む役割があります。
ここでいう「特異メソッド」とは、クラスオブジェクトや特定のインスタンスにだけ定義されるメソッドのことです。

### 継承チェーンとの関連
extend はクラス自身やインスタンス自身に対してモジュールを「特異クラスレベル」でミックスインします。
クラスに対して行う場合、そのクラスメソッドとして使用できるようになります。

### クラスに対してextendする場合
```ruby
module M
  def hello
    "Hello from M"
  end
end

class C
  extend M
end

p C.hello  # => "Hello from M" (クラスメソッドとして呼び出せる)
```
extend は “クラス自身（= クラスオブジェクト）の特異クラス” にモジュールを取り込むため、メソッド探索順としては「C の特異クラスの先頭」に M が来ます。

### インスタンスに使用した場合
あるオブジェクト（インスタンス） obj に対して obj.extend(M) と呼ぶと、そのオブジェクトの特異クラスにモジュール M が取り込まれます。すると、

* その特定のオブジェクトだけが M のメソッドをインスタンスメソッドのように呼べる
* メソッド探索の順番で、最後に extend したモジュールが最優先で探される

という特徴があります。




```ruby
module M
  def hello
    "Hello from M"
  end
end

class C
end

obj1 = C.new
obj2 = C.new

obj1.extend(M)   # obj1 のみ M を extend
p obj1.hello     # => "Hello from M"
p obj2.hello     # => NoMethodError (C や obj2 には hello がない)
```
obj1の継承チェーン
```ruby
[#<M>, C, Object, Kernel, BasicObject]
```
obj2の継承チェーン
```ruby
[C, Object, Kernel, BasicObject]
```
上記を見てわかる通り、obj1にのみmodule Mが挿入されていることがわかります

### 複数モジュールをインスタンスに対して extendした場合
```ruby
module A
  def greet
    "Hello from A"
  end
end

module B
  def greet
    "Hello from B"
  end
end

class C
end

obj = C.new
obj.extend(A)
obj.extend(B)

p obj.greet
# => "Hello from B"
```
上記の最終的なメソッド探索順は
```ruby
[B, A, C, Object, Kernel, BasicObject]
```
となり、B が先に探されるため "Hello from B" が表示されます。

## prepend
prepend は include と似ていますが、**クラスの継承チェーンの先頭にモジュールを挿入します**。
そのため、同名メソッドがあった場合はモジュールのメソッドが優先されます

```ruby
module OverrideGreet
  def say_hello
    puts "Hello from OverrideGreet!"
    super  # 元のクラスの say_hello を呼び出す
  end
end

class Person
  def say_hello
    puts "Hello from Person!"
  end

  prepend OverrideGreet
end

person = Person.new
person.say_hello
# => "Hello from OverrideGreet!"
# => "Hello from Person!"
```
継承関係(一例)
```ruby
person.ancestors #=>[ModuleName,MyClass,SuperClass,Object ...]
```

prepend により、OverrideGreet が先に呼び出されます。その後に super が呼ばれると、次の場所（Person クラス）を探索してメソッドが実行されます。


# まとめ
* module は、複数のクラスで再利用したいメソッドや定数をまとめる仕組み
* include は、モジュールのメソッドを “インスタンスメソッド” としてクラスに取り込む
* extend は、モジュールのメソッドを “特異メソッド（クラスメソッド）” として取り込む
* prepend は、クラスの継承チェーンの先頭にモジュールを挿入し、同名メソッドを上書きできる
以上で、Ruby の module と include, extend, prepend の使い方・違いについてまとめました。ぜひ参考にしてみてください。
