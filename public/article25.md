---
title: 【Ruby】多重代入を忘れないために
tags:
  - Ruby
  - 未経験エンジニア
  - 未経験からWeb系
  - 多重代入
private: false
updated_at: '2024-10-26T05:16:40+09:00'
id: a41c22392637f47b2a21
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは、絶賛Ruby勉強中のものです。
今回は多重代入について扱いたいと思います。
現在「たのしいRuby」を使用して勉強しているのですが、多重代入を勉強してこれはとても便利な一方アウトプットして定期的に目に入れないと忘れる…と感じたので、今回は気づきというよりは多重代入についてまとめた記事になります。

# 多重代入の基本構文
Rubyでは多重代入を利用して、以下のように一行で複数の変数に値を代入することができます。
```ruby:multiple_imputation1.rb
a, b, c = 1, 2
p a  # => 1
p b  # => 2
```
`a`, `b`にそれぞれ`1`, `2`が代入されています。
～～～(コメントより補足)～～～
多重代入自体便利ではありますが、上記の例だと行数を減らす以上のメリットがなくごちゃごちゃしているので以下のように書くようです
```ruby:multiple_imputation2.rb
a = 1
b = 1

p a  # => 1
p b  # => 2
```
～～～～～
複数の変数に対して、対応する値をカンマ区切りで一度に代入できるのがポイントです。
続いて多重代入のいくつかのパターンについてみていきましょう

## 値の数が変数の数と一致しない場合
もし値の数が変数の数と一致しない場合でも、Rubyは柔軟に対応します。
値の数が変数より少ない場合は、余った変数には`nil`が代入されます。
```ruby:multiple_imputation3.rb
x, y, z = 10, 20
p x  # => 10
p y  # => 20
p z  # => nil
```
では、変数の数より値が多い場合はどうなるでしょう
```ruby:multiple_imputation4.rb
a, b = 1, 2, 3
p a  # => 1
p b  # => 2
```
上記の場合は`3`を無視してくれる挙動をとってくれます。

～～～(コメントより補足)～～～
代入する値が代入先よりも多い場合ですが，<strong>代入先が 1 個の場合</strong>は「余りを無視」とはなりません：
```ruby:comment.rb
a = 1, 2, 3
p a # => [1, 2, 3]
```

## 配列を使った多重代入
多重代入は、配列を展開して変数に代入する際にも非常に便利です。
```ruby:array1.rb
arr = [10, 20, 30]
x, y, z = arr
# 本来ならば3行必要ですが、1行で済むのでとても便利です
# x = arr[0]
# y = arr[1]
# z = arr[2]

p x  # => 10
p y  # => 20
p z  # => 30
```
## 多重代入と残りの要素をまとめる方法
場合によっては、最初の数個の要素だけを変数に代入し、残りの要素を一つの配列としてまとめたいことがあります。
Rubyでは、`*`（スプラット演算子）を使って残りの要素をまとめることができます。
```ruby:splat1.rb
a, *b = 1, 2, 3, 4, 5
p a  # => 1
p b  # => [2, 3, 4, 5]
```
もちろん、スプラット演算子は末尾以外にも使用できます。
```ruby:splat2.rb
*a, b = 1, 2, 3, 4, 5
p a  # => [1, 2, 3, 4]
p b  # => 5
```

## 値の交換にも便利
多重代入のもう一つの便利な使い方は、値の交換です。
多くのプログラミング言語では、変数同士の値を交換する際に一時変数を使いますが、Rubyでは多重代入を使うことでシンプルに書けます。
```ruby:change_number1.rb
x = 1
y = 2

x, y = y, x
p x  # => 2
p y  # => 1
```
一時変数を使わずに、`x`と`y`の値を簡単に入れ替えることができました。
これは、配列の要素を入れ替える時や、アルゴリズムでの値の操作に非常に有効です。
ちなみにもし、多重代入を使わないで上記の処理を行おうとすると
```ruby:change_number1.rb
x = 1
y = 2
tmp = x
x = y
b = tmp

p x  # => 2
p y  # => 1
```
となり一時変数が出てくる処理となるのです。

## メソッドの戻り値を使った多重代入
多重代入は、メソッドの戻り値を複数の変数に受け取る場合にも便利です。
メソッドから配列を返し、その要素を個別に変数に代入することができます。
```ruby:cal.rb
def calculate(a, b)
  sum = a + b
  diff = a - b
  [sum, diff]  # 戻り値
end

result_sum, result_diff = calculate(10, 5)
p result_sum   # => 15
p result_diff  # => 5
```

## ブロックパラメータへの代入(追記)
コメントいただいたので、内容を追加しておきます。
多重代入はブロックパラメータにおいても使われるようです
```ruby:comment2.rb
feeding = {朝: 3, 暮: 4}

feeding.each do |time, amount|
  puts "#{time}は#{amount}個"
end
```
ここで使われている `Hash#each` は，ブロックに対し，キーと値のペアを配列にしたもの（上記の例では `[:朝, 3]` など）を渡します。
上記のコードでは，その配列を `time` と `amount` という二つのブロックパラメーターで受けているのです。

# まとめ
Rubyの多重代入は、一度に複数の変数に値を代入できる便利な機能ということがわかっていただけましたでしょうか。
とは言っても代用のきく操作であるので忘れないように定期的に思い出したり、使用して定着させていきましょう。
