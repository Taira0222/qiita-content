---
title: 【Ruby】Random.randとRandom.newの違い
tags:
  - Ruby
  - Random
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-11-06T09:44:32+09:00'
id: 7959d4184ffdcb790c12
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。
本日は乱数を作成するための`.rand`メソッドと`.new`メソッドの違いについて説明していきたいと思います

# `Random.rand`とは
`Random.rand`は、Rubyの`Random`クラスに定義されているクラスメソッドです。
クラスメソッドなので、インスタンスを作成することなく、Random.randと直接呼び出せます。
このメソッドを使用する場合、Rubyのグローバルな乱数生成器が使われます。
特徴としては以下の通りです
* 手軽に使える
`Random.rand`はどこからでも簡単に呼び出せます。
* グローバルな乱数生成器を使用
プログラム全体で同じグローバル乱数生成器を共有するため、何度も呼び出しても使い回されます。
* 再現性が低い
プログラムの実行ごとに異なる乱数が生成され、再現性が必要な場合には不向きです。

```ruby
# 0から9までの乱数を生成
puts Random.rand(10)

# 1から6までの乱数を生成（サイコロの目のように）
puts Random.rand(1..6)
```
`Random.rand`を使うと簡単に乱数を生成できますが、シード値の設定ができないため、常に異なる結果が得られる点に注意が必要です。

# `Random.new`とは
一方、`Random.new`は`Random`クラスのインスタンスメソッドを利用する方法です。
`Random.new`を使うと、新しい乱数生成器のインスタンスを作成し、`rand`メソッドを使って乱数を生成できます。
この方法ではシード値を設定することができ、同じシード値であれば同じ乱数列が生成されるため、再現性が求められる場面に適しています。

ちなみにシード値というのは、乱数の生成を開始する「初期値」のようなものです。
例えば、Random.new(1)とすると、シード値が「1」となり、このインスタンスで生成される乱数列は常に同じになります。シード値を変更すると生成される乱数列も変わるため、乱数の再現性を確保したい場合に便利です。

少しずれましたが、続いて`Random.new`特徴は以下の通りです

* 独立した乱数生成器
`Random.new`で生成した乱数生成器はグローバルとは独立しており、他のコードでの乱数生成の影響を受けません。
* シード値を設定可能
シード値を指定して生成すると、実行のたびに同じ乱数の列が得られ、テストなどで結果を再現したい場合に便利です。
* 再現性がある
同じシード値を設定した`Random.new`インスタンスは、毎回同じ乱数列を返します。
```ruby
r1 = Random.new(1) # 乱数列を初期化する

p [r1.rand, r1.rand]
# => [0.123456789,0.987654321]

r2 = Random.new(1)　# 乱数列を再び初期化する
p [r2.rand, r2.rand]
# => [0.123456789,0.987654321]

r3 = Random.new(2) # シード値を変更する
p [r3.rand, r3.rand]
# => [0.543843871,0.734416826] 
```
`r1`と`r2`は同じシード値なので、乱数列を初期化すると同じ数字が出てきますが、`r3`はシード値が異なるため違う乱数列が出てきます

# `Random.rand`と`Random.new`の使い分け
では、どのような場面でどちらを使えば良いのでしょうか？以下に簡単なガイドラインを示します。

* 手軽に乱数を生成したい場合
`Random.rand`が便利です。シード値を意識せずにランダムな結果が必要なときに最適です。
* テストや再現性が必要な場合
`Random.new`を使いましょう。同じ結果を得たい場合に、シード値を指定したインスタンスを利用すると一貫した乱数が得られます。

# まとめ
本日は乱数生成について触れてみました。
HTMLやCSS、データベースあたりを勉強していた際はそこまで数学って感じではないかなと思っていましたが、最近勉強している内容は数学を想起させるような内容ばかりです。
またRubyの記事を上げていくのでよろしくお願いします。