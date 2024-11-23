---
title: 【Ruby】こんな間違いをしてしまった(正規表現)
tags:
  - Ruby
  - 正規表現
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-11-23T13:37:09+09:00'
id: 8b895b0b36bc87de49a4
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。
今回も正規表現に関する記事です。
私は「たのしいRuby」という教材を使用して勉強しているのですが、問題を間違えてしまいました。
そこで今回は、「初心者が陥りやすいミス」として記事にまとめることにしました。
初心者の方はこれを参考にしてミスを避けていただき、経験豊富なエンジニアの方には指導の際の参考にしていただければ幸いです。

# 間違えた内容
以下のような word_capitalize メソッドを定義する問題が出題されました。
正規表現を使って、以下のように考えました（誤りの例です）。
```ruby
def word_capitalize(word)
  word.gsub(/.+-/) do |matched|
    matched.capitalize
  end
end

p word_capitalize("in-n-out") # => "In-n-out"
```
`/.+-/` は、「任意の文字列を1回以上使用したものとハイフン」にマッチするつもりでしたが、期待通りには動作しませんでした。

# 間違えた原因
間違えた原因は次の通りです。
* `/.+-/` では、`in-n-out` のうち、`in-n-` しか取得できませんでした。
(追記)これは、量指定子`+`の「最長一致の原則」が聞いているため、可能な限り長い文字列をとっているからです。
* gsub のブロックはマッチした部分だけを処理するため、繰り返し処理を適切に組まないと、文字列全体を操作できない点に気づけませんでした。

# 解決策
### 解決策1: `\b` を利用する
```ruby
def word_capitalize(word)
  word.gsub(/\b[a-z]/) do |matched|
    matched.upcase
  end
end

p word_capitalize("in-n-out") # => "In-N-Out"
```
`\b` によって単語の境界を検出し、小文字アルファベットにマッチしています。
この例では i, n, o が検出され、それぞれが大文字に変換されます。

### 解決策2: `split`, `map`, `join` を利用する
```ruby
def word_capitalize(word)
  word.split("-").map{|i|i.capitalize}.join("-")
end

p word_capitalize("in-n-out")
# => "In-N-Out"
```
処理の手順は以下の通りです
* `split("-")` によりハイフンを取り除いて文字列を配列化（例: `["in", "n", "out"]`）。
* `map { |i| i.capitalize } `で各部分を大文字化（例: `["In", "N", "Out"]`）。
* 最後に `join("-")` で結合して元の形式に戻します。

# まとめ
今回は、正規表現と gsub を使う際に、繰り返し処理を正しく設計しなかったために誤りが生じました。
「間違えたシリーズ」を通じて、同じようなミスを減らし、業界全体の理解度向上に少しでも貢献できたら嬉しいです。
