---
title: 【Ruby】後置ifは便利だけど計画的に使おう
tags:
  - Ruby
  - 未経験エンジニア
  - 後置if
private: false
updated_at: '2024-10-05T07:42:22+09:00'
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
puts "Your score is low." if score < 50; score += 10 if score < 50
```
普通のif文を見ればそこまで難しいコードでないことがわかるとおもいます
```ruby:good2.rb
if score < 50
  puts "Your score is low."
  score += 10
end
```

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
puts "Excellent!" if score > 90 if passed
```

これも上記同様普通のif文と比べてみましょう
```ruby:good4.rb
if passed
  if score > 90
    puts "Excellent!"
  end
end
```
普通のif文を使ったほうが明らかに可動性高いことがわかります

# まとめ
今回は後置ifについての記事を作成しました。
短い分量でサクッとif文作れるのはとても魅力的ですが、複雑な条件の場合やネストが深くなる場合などの使用は極力さけて使いましょう。

