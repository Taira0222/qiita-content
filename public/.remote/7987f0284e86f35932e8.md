---
title: 【Ruby】今日書いたコードの振り返り(演算子)#11
tags:
  - Ruby
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-07T06:50:27+09:00'
id: 7987f0284e86f35932e8
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指しているものです。
本日は演算子の問題を扱っていきたいと思います。


## 問題内容
Person クラスに 、名前の長さを元に大小を比較できるようにしてください。
複数の Person オブジェクトを配列に格納し、sort メソッドを呼び出したときに、名前の長さが短い順・長い順に並び替えられることを確認してみましょう。

出力例

```ruby


people = [
  Person.new("Eve"),
  Person.new("Bob"),
  Person.new("Alexander"),
  Person.new("Dave")
]

sorted_people = people.sort
p sorted_people.map(&:name)
# 期待する並び: ["Bob", "Eve", "Dave", "Alexander"]  (名前の長さ: 3, 3, 4, 9)
```

## 私の解答
<=>（スペースシップ演算子） を定義してと問題に書いてありましたが、これを用いたコードの書き方を知らずほかの方法で試しました

```ruby
class Person
    @@people = []

    attr_reader :name

    def initialize(name)
        @@people << name
    end

    def self.sort
        @@people.sort_by{|i|[i.size, i]}
    end


end

person1 = Person.new("Eve"),
person2 = Person.new("Bob"),
person3 = Person.new("Alexander"),
person4 = Person.new("Dave")

p Person.sort
# => ["Bob", "Eve", "Dave", "Alexander"]  (名前の長さ: 3, 3, 4, 9)
```
上記の方法でも実装できたと思いましたが、これではデメリットがいくつか存在します
* 複数の Person 集合を扱いにくい
* 名前以外の情報を扱いにくい
* グローバルで書き換えられるためバグが起きやすい

### 複数の Person 集合を扱いにくい
たとえば、「男性の集まり」と「女性の集まり」を別の配列で扱いたい場面を想像してください。
現在の実装では、全ての Person インスタンスを作るたびに @@people に1 つの配列として混ぜ込まれていくため、「男性配列」「女性配列」に分けて管理できません。
```ruby
men = []
women = []

men << Person.new("Bob")       # @@people = ["Bob"]
women << Person.new("Alice")   # @@people = ["Bob", "Alice"]

# Person.sort すると Bob と Alice が混ざって並び替えられる
```
もし男性だけをソートしたい、女性だけをソートしたいと思っても、すでに @@people に全部混ざっているため、抽出や分離が面倒です。
複数グループを独立して扱いたい場合には、クラス変数1本だけに全部のインスタンスを詰め込む設計は不便になります。

#### スペースシップ演算子を使うとどうなる？
スペースシップ演算子を Person クラスに定義し、それぞれの配列（例: men, women）が Person オブジェクトを直接持つようにすれば、次のようにグループごとに独立してソートできます。
```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  # スペースシップ演算子: 名前の長さで比較
  def <=>(other)
    self.name.length <=> other.name.length
  end
end

men = [
  Person.new("Bob"),
  Person.new("Dave")
]

women = [
  Person.new("Alice"),
  Person.new("Eve")
]

sorted_men   = men.sort
sorted_women = women.sort

p sorted_men.map(&:name)     # ["Bob", "Dave"]  (名前の長さ: 3, 4)
p sorted_women.map(&:name)   # ["Eve", "Alice"] (名前の長さ: 3, 5)
```

### 名前以外の情報を扱いにくい
今後 Person に「年齢」や「メールアドレス」などの別属性を追加して、それも踏まえてソートしたい…という要件が出るケースはよくあります。
@@people は現在「名前の文字列」しか持てないので、次のように「年齢」を追加したい場合どうしますか？
```ruby
class Person
  @@people = []

  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age  = age
    # @@people の中身も？ 
    #   - 今までは「名前の文字列」だった
    #   - これからは { name: "...", age: ... } みたいなハッシュを入れる？
    #   - もしくは Person インスタンスごと @@people に入れる？
  end

  def self.sort
    # これまで sort_by { |i| [i.size, i] } だったが、
    # もし i がハッシュなら、i[:name].size と i[:age] をどう比較？ など、改修が複雑
  end
end
```
結局、クラス変数に保持している要素の型・構造をガラッと変える必要が出てくるので、すぐに複雑化します。

もともと「Person オブジェクト」自体が name や age を持っていれば、sort はオブジェクト同士を比較するだけで済むはずです。しかし、クラス変数を文字列しか想定していない設計だと拡張が難しくなるのです。

#### スペースシップ演算子を使うとどうなる？
以下のように Person クラスに複数の属性を持たせ、ソートの優先順位を明確にしてあげれば、同じ配列内で柔軟な比較が可能です。

```ruby
class Person
  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age  = age
  end

  # スペースシップ演算子: 
  # まず名前の長さで比較し、同じなら年齢で比較する
  def <=>(other)
    result = self.name.length <=> other.name.length
    result.zero? ? self.age <=> other.age : result
  end
end

people = [
  Person.new("Bob", 20),
  Person.new("Eve", 22),
  Person.new("Dave", 20),
  Person.new("Alexander", 19)
]

sorted_people = people.sort
p sorted_people.map { |p| [p.name, p.age] }
# => [["Bob", 20], ["Dave", 20], ["Eve", 22], ["Alexander", 19]]
#    (名前長さ: 3, 4, 3, 9 の順。Bob と Eve は名前の長さが同じなので年齢比較)
```
このように、複数の属性を持つオブジェクトでも比較方法を自由に定義できます。クラス変数に文字列のみを詰め込む必要がなくなるので、保守性や拡張性を大幅に向上できます。

### グローバルで書き換えられるためバグが起きやすい
`@@people` は、クラスが読み込まれている限りどこからでもアクセス・変更できる状態です。
極端な例でいうと、別のメソッドや別のファイルから意図せず `@@people.clear` されたり、要素を取り除かれたりしても防ぎようがありません。

オブジェクト指向では、「オブジェクトの状態は極力オブジェクトの中だけで管理し、不要に外部から変更できないようにする」ことが好まれます。クラス変数はスコープが広すぎるため、バグや予期せぬ動作を招くリスクが高いです。

## 解答例
これはchatgptの作成によるものです。ほかにいいコードがあればフィードバックいただけると幸いです

```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  # 名前の長さで比較する <=> の定義
  def <=>(other)
    self.name.length <=> other.name.length
  end
end

people = [
  Person.new("Eve"),
  Person.new("Bob"),
  Person.new("Alexander"),
  Person.new("Dave")
]

sorted_people = people.sort
# Person オブジェクトを name の配列で確認
puts sorted_people.map(&:name).inspect
#=> ["Bob", "Eve", "Dave", "Alexander"]
#   (名前の長さ順: 3, 3, 4, 9)
```
このメソッドは「スペースシップ演算子」と呼ばれるものです。
Ruby の Array#sort や Array#sort_by、Enumerable#max / #min など、要素同士を比較する必要があるメソッドが呼ばれたときに、Ruby は暗黙的にこの <=> を呼び出して、オブジェクト同士の大小を判断します。

今回はpeople.sortで呼び出しているのでそのタイミングでdef <=>が呼び出されます
なおここでいうohterは比較対象のインスタンスになります

## 追記
コメントで指摘をいただいたので、追記いたします
今回はスペースシップ演算子を使用していますが、効率のみを考えるとベストではないといえます。
```ruby
 def <=>(other)
    self.name.length <=> other.name.length
  end
```
上記のスペースシップ演算子によるメソッドの場合、1回比較するに`name.length`が2回呼び出されています。
また、`sort`を使用して要素数が`n`の配列をソートする際に比較回数はアルゴリズムの都合上`nlogn`回となるので合計`nlogn × 2`回となります

一方で `sort_by` は、**「まずブロックを各要素に 1 回ずつだけ適用して“キー”を取り出し、あとはその“キー”を使って比較する」** というアルゴリズムをとります。
要素数 `𝑛` なら、`name.length` を計算するのは 最初に各要素に対して 1 回ずつ、合計 `𝑛` 回だけです。
比較に使うのはあらかじめ得られた数値（たとえば 3, 9 といった “名前の長さ” の整数）なので、後のソート処理では重たいメソッドを再度呼ばないで済みます。またsort_byを使えば<=>メソッドを設定する必要もありません。
```ruby
# 例: sort_by の場合
people.sort_by { _1.name.length }
# => sort_by の内部で:
#    1) 各要素に対して name.length を1回ずつだけ計算し、結果をまとめる
#    2) まとめた長さのリスト（整数）を比較のキーにしてソートする
```
演算子を使うという趣旨からは外れますが、実務のことを考えると効率的(呼び出い回数が少ない)なコードを覚えていた方がいいと思いました

それを踏まえた別解を載せておきます
```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

people = [
  Person.new("Eve"),
  Person.new("Bob"),
  Person.new("Alexander"),
  Person.new("Dave")
]

sorted_people = people.sort_by { _1.name.length }

puts sorted_people.map(&:name).inspect
#=> ["Bob", "Eve", "Dave", "Alexander"]
#   (名前の長さ順: 3, 3, 4, 9)
```

# まとめ
今回はスペースシップ演算子を使ったコードを扱いました。私の書いたコードでも結果自体は同じでしたが、保守性・拡張性、そしてセキュリティ面を考慮すると、あまりよい設計とは言えない部分がありました。
実装後に、よりよいコードを見る機会を得られるのは大切なことです。今後、同じような課題に直面した際には、今回学んだ知識を活かして対処できるようにしたいと思います。
