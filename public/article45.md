---
title: 【Ruby】each_indexメソッドとselectメソッドの性質の違い
tags:
  - Ruby
  - 初心者
  - select
  - 独学
  - each_index
private: false
updated_at: '2024-11-14T12:58:28+09:00'
id: ff32660807cf89c774a6
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。
現在`Array`クラスを勉強中ですが、その中でも`each_index`メソッドと`select`メソッドの意外な違いを発見したので記事にしようと思いました

# `each_index`メソッドとは
まず、`each_index`メソッドについて簡単に説明します。
`each_index`は、<strong>配列の各インデックスを順に処理するためのメソッド</strong>です。
通常、配列のインデックスに基づいた操作を行う際に便利ですが、重要な点は、<strong>新しい配列を作成する機能を持たない</strong>ということです。

```ruby
a = [10, 20, 30, 40, 50]
a.each_index do |index|
  puts "インデックス: #{index}, 値: #{a[index]}"
end
```
このコードでは、各インデックスを順に取得し、対応する要素を出力しています。
しかし、この操作は元の配列を参照するだけで、新しい配列を作成する機能はありません。
そのため、もし特定の条件に基づいて要素を抽出し、新しい配列に格納したい場合は、<strong>空の配列を初期化して自分で要素を追加する処理を記述する必要</strong>があります。

### (補足)each_with_indexのほうがこの場合はわかりやすい
コメントいただいたので補足として加えておきます。上記のように要素とインデックスを使用する場合は`each_with_index`を使用した方がわかりやすいです
```ruby
a = [10, 20, 30, 40, 50]
a.each_with_index do |value, index|
  puts "インデックス: #{index}, 値: #{value}"
end
```

each_indexを用いて特定の条件に一致する要素を集める場合は以下のように書く必要があります
```ruby
a = Array.new(100) { |i| i + 1 }
a3 = [] # 新しい配列を初期化

a.each_index do |index|
  if a[index] % 3 == 0
    a3 << a[index] # 条件を満たす要素を新しい配列に追加
  end
end

p a3
```
この例では、3の倍数を抽出して新しい配列a3に格納しています。
`each_index`は新しい配列を作成する機能を持たないので、上記のように、新しい配列を作成する際は自分で初期化する必要があります。

### (補足)上記の場合はeachのほうがシンプルでわかりやすい
上記のコードを`each_index`で書いてしまいましたが、`each`のほうがこの場合はシンプルで保守性も考えたら適切かなと思いました
```ruby
a = Array.new(100) { |i| i + 1 }
a3 = [] # 新しい配列を初期化

a.each do |x| 
  if x % 3 == 0 
    a3 <<x # 条件を満たす要素を新しい配列に追加 
  end
end

p a3
```

# `select`メソッド
次に、`select`メソッドについて見ていきましょう。
`select`は、<strong>配列の各要素を順に評価し、条件を満たす要素を新しい配列にまとめて返す</strong>イテレータメソッドです。
`select`は内部で新しい配列を自動で作成し、条件に一致する要素を格納して返してくれるため、<strong>新しい配列の初期化が不要</strong>です。
`select`を用いて特定の条件に一致する要素を抽出すると以下のようになります
```ruby
a = Array.new(100) { |i| i + 1 }
a3 = a.select { |i| i % 3 == 0 }
p a3
```
このコードでは、`select`メソッドが自動で3の倍数を集めて新しい配列を生成し、`a3`に代入しています。
`select`を使用することで、簡潔に記述でき、余分な初期化や要素の追加処理が不要になります。

# `each_index`と`select`の違いをまとめると
### 目的の違い
`each_index`は配列のインデックスに基づいた処理を行うためのメソッドであり、元の配列を操作する用途に向いています。
新しい配列を作成する機能は持たないため、別途配列を初期化する必要があります。
`select`は、特定の条件に一致する要素を集めて新しい配列を返すことが主な役割です。そのため、新しい配列を自動で作成して返す仕様になっています。

### 実装の違い

`each_index`では、要素を集めたい場合、自分で新しい配列を初期化し、<<で要素を追加する手間が必要です。
`select`では、条件に一致する要素を自動的に新しい配列に格納して返してくれるため、初期化不要で簡潔な記述が可能です。

# まとめ
`each_index`と`select`は、用途や性質が異なるメソッドですが、それぞれ適した場面で使用することで効率的な配列操作が可能です。
特に、新しい配列を作成する際の初期化の有無について理解することで、コードの記述がスムーズになります。
事前に知っておくことで、余計なコードを書く手間が減り効率のよいコードを書くことができるようになります。
