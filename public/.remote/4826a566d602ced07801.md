---
title: 【Ruby】今日書いたコードの振り返り(CSVライブラリ)#13
tags:
  - Ruby
  - CSV
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-23T15:49:58+09:00'
id: 4826a566d602ced07801
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指している者です。
本日は Ruby の Array クラスの演習をしていたところ、標準ライブラリの CSV を使う機会があったので、使い方を忘れないうちに備忘録として記事にまとめようと思いました。

## 問題内容
1. users.csv が以下のような形式で与えられます。（ヘッダ行あり）
```csv
name,age
Alice,30
Bob,25
Carol,35
```
2. これを読み込んで、[{name: "Alice", age: 30}, {name: "Bob", age: 25}, ...] のような配列として扱ってください。
3. 配列を age 昇順（年齢が小さい順）にソートし、結果を出力してみましょう。

## 解答例
Chatgpt o1にて出力しました。あくまでも解答例です

```ruby
require 'csv'

users = []

CSV.foreach("users.csv", headers: true) do |row|
  users << {
    name: row["name"],
    age:  row["age"].to_i
  }
end

# ageの昇順にソート
sorted_users = users.sort_by { |u| u[:age] }

puts "ソート結果:"
sorted_users.each do |user|
  puts "#{user[:name]} (#{user[:age]})"
end

```
`users.csv`のファイル内容は以下の通りとします。
```csv:users.csv
name,age
Alice,30
Bob,25
Carol,35
```

### 解説
1. `CSV.foreach("users.csv", headers: true) do |row|`
* `CSV.foreach`: CSVライブラリの特異メソッド`foreach`を使用しています。
* `headers: true`: オプションで`true`にすると最初の行はヘッダー(列名)として扱われます。なおデフォルトは`false`です
* `row`: CSV::Row オブジェクトで、ハッシュに似た操作が可能です。ただし、厳密にはハッシュではありません。
2. `users << {name: row["name"], age: row["age"].to_i }`
* `row["name"]`: CSVファイルの「name」列に入っている文字列データを取得します。
* `row["age"]`: CSVファイルの「age」列に入っている文字列データを取得します。


## まとめ
今回、Ruby の標準ライブラリである CSV を使ってファイルを読み込み、配列に格納する方法を学びました。演習として CSV::Row を用いる形を初めて知ったのですが、実務でもデータの取り込みで頻出する処理だと思うので、とても良い学習になりました。
