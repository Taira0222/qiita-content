---
title: 【Ruby】後置ifは便利だけど計画的に使おう
tags:
  - Ruby
  - 未経験エンジニア
  - 後置if
  - 未経験からWeb系
private: false
updated_at: '2024-10-21T14:12:47+09:00'
id: fc3824636b4a783cce3e
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
本日は後置ifについての記事を書きたいと思います。
後置ifとは簡潔で読みやすいコードを書くための構文で、条件分岐を一行で書けるようにします。
主に、シンプルな条件を確認して動作を行いたいときや、コードの可読性を高めたいときに使用します。
後置ifの基本構文は`処理 if 条件`になります

## 後置ifのメリット
例えばこれは普通の`if`文です
```ruby:if.rb
if is_holiday
  puts "Enjoy your day!"
end
```
一方後置ifを使用すると
```ruby:back_if.rb
puts "Enjoy your day!" if is_holiday
```

とこんな感じで1行で済ませることができるのです。
メリットをまとめると
* コードが簡潔になる
* 可読性の向上
* 無駄なインデントを減らす
* 軽量な条件処理に向いている

## 後置ifのデメリット
上記を見る限りだとメリットのほうが多いからこれからは後置ifを多用しようと思いますよね。
しかし後置ifを使うことで可読性が逆に落ちてしまう例もあるのです
* 複雑な条件の場合
* 複数の処理を実行する場合
* elseが必要な場合
* ネストが深くなる場合

### 複雑な条件の場合
例えばこのコードを見てください。
```ruby:bad1.rb
puts "You passed!" if score > 60 && (attendance_rate > 80 || special_permission)
```
まあ読めなくはないが、横にずらーっと長くなってしまうのでとても見ずらいですね。

### 複数の処理を実行する場合
複数処理を実行する際にも後置ifはみずらくなってしまいます
```ruby:bad2.rb
puts "Processing data..." if ready
update_data if ready && granted
send_notification if notify && granted
```
ここでは ready、grantedなどの条件が絡むため、それぞれの処理が独立して散らばっており、どの条件で何が行われるのかを理解するのに時間がかかります。
また、同じ条件（granted など）が何度も出てくるため、条件の関係性が混乱しやすくなります。
```ruby:good2.rb
if ready
  puts "Processing data..."
  if granted
    update_data
    send_notification if notify
  end
end
```
これによって、同じ条件を繰り返し書く必要がなく、処理が一箇所にまとまるため、可読性が向上します。

### elseが必要な場合
後置ifはelseをサポートしていないため、条件によって異なる処理を行いたい場合には通常のif-else文を使うべきです。
```ruby:bad3.rb
puts "You're an adult." if age >= 18
puts "You're a minor." if age < 18
```

### ネストが深くなる場合
後置ifで条件をネストするのは避けたほうがいいです。
ネストが深くなると、読み手が条件の流れを理解するのが難しくなります。
```ruby:bad4.rb
puts "You passed with distinction!" if score > 90 if passed
puts "You passed!" if score.between?(60, 90) if passed
puts "You failed!" if score < 60 || !passed
```
それぞれの条件が別々に処理されているため、条件の分岐が複雑になるにつれ、どの条件がどの出力に対応するのかが分かりにくくなっています。
特にscore.between?(60, 90)やscore < 60など複数の条件があると、後置ifでは直感的に理解しにくくなります。
```ruby:good4.rb
if passed
  if score > 90
    puts "You passed with distinction!"
  elsif score.between?(60, 90)
    puts "You passed!"
  else
    puts "You failed!"
  end
else
  puts "You failed!"
end
```
特にelsifを含むような分岐や複雑なロジックが絡む場合、後置ifは逆にコードを難読化してしまうデメリットがあることがここから分かると思います。

# まとめ
今回は後置ifについての記事を作成しました。
短い分量でサクッとif文作れるのはとても魅力的ですが、複雑な条件の場合やネストが深くなる場合などの使用は極力さけて使いましょう。

