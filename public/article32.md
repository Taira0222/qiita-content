---
title: 【Ruby】インスタンスメソッドとクラスメソッドの使いわけ
tags:
  - Ruby
  - 初心者
  - 未経験エンジニア
  - クラスメソッド
  - インスタンスメソッド
private: false
updated_at: '2024-10-30T12:28:54+09:00'
id: ac9ada7c05fb07b6526b
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは、絶賛Ruby勉強中のものです。
本日はRubyのインスタンスメソッドとクラスメソッドの使い分けについて説明していきたいと思います
Rubyの経験がまだ浅い私は、クラスメソッドの使い時をあまり理解しておらずインスタンスメソッドで代用できるのでは？と考えておりました。
そこで本日はインスタンスメソッドとクラスメソッドの使い分けについて記事を書いていこうと思います。
なお、インスタンスメソッドとクラスメソッドの説明については、記事を書いたので詳しく見たい方は確認していただければ幸いです。

https://qiita.com/Taira0222/items/aca062a0cfb879fded31

# インスタンスメソッド
まずは、フルネームと年齢を取得する`User`クラスと`user1`,`user2`インスタンスについてみていきましょう。
```ruby:instance.rb
class User
  attr_accessor :first_name, :last_name, :age
  
  def initialize(first_name, last_name, age)
    @first_name = first_name
    @last_name = last_name
    @age = age
  end
  
  # インスタンスメソッド
  def full_name
    "#{@first_name} #{@last_name}"
  end
end

# インスタンスメソッドの利用例
user1 = User.new("Taro", "Yamada", 25)
user2 = User.new("Hanako", "Tanaka", 30)

puts user1.full_name  # => "Taro Yamada"
puts user2.full_name  # => "Hanako Tanaka"
```
上記のコードでは、`full_name`メソッドを使って`User`のインスタンスである`user1`からフルネームを取得しています。`user2`も同様です。
このように、<strong>インスタンスメソッドはインスタンスごとに異なる値を持つデータに対して処理を行う</strong>ため、個別のユーザー情報を扱いたいときに便利です。
ほかにも鈴木さんとか山本さんとか様々な方の名前をこのクラスで作っていくと思いますが、人数を何人か数えたい場面が出てくると思います。


# クラスメソッド
そこでクラスメソッドを使うと比較的楽に処理できます。
```ruby:class.rb
class User
  attr_accessor :first_name, :last_name
  @@user_count = 0  # ユーザーの総数を格納するクラス変数

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @@user_count += 1  # インスタンスが生成されるたびにカウント
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

  # クラスメソッド
  def self.total_users
    @@user_count
  end
end

# 利用例
user1 = User.new("Taro", "Yamada")
user2 = User.new("Hanako", "Tanaka")

puts User.total_users  # => 2
```
`@@user_count`というクラス変数で、`User`インスタンスが作成されるたびにユーザー数をカウントしています。
クラスメソッド `self.total_users` を使うことで、`User`クラスにどれだけのユーザーが登録されているかを確認できます。
このように、<strong>クラスに関する全体的な情報（今回はユーザーの総数）を管理したい場合</strong>にクラスメソッドを使うと便利です。

# まとめ
上記の例を踏まえて、それぞれどのような場面で使用するかまとめていきます。
* インスタンスメソッドは個別のデータを処理するため、インスタンスごとの値を操作したい場合に使います。
* クラスメソッドはクラス全体に関連する情報を操作するため、インスタンスの生成が不要な処理や、複数のインスタンスを横断するデータを扱いたいときに使います。
