---
title: 【Ruby】%記法のまとめ
tags:
  - Ruby
  - 初心者
  - 未経験エンジニア
  - '%記法'
  - 独学
private: false
updated_at: '2024-11-10T07:21:17+09:00'
id: 5f29e6f055fb544e0741
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。
現在たのしいRubyという教材を使用してArrayクラスについて学んでいますが、その中で%記法(%wと&i)を習いました。
もしかしたら、これら以外にも%記法があるのでは？と思い調べたのがこの記事を書こうと思ったきっかけです。
では、%記法について解説します。

## `%q` と `%Q`（文字列）
* `%q`：シングルクォート（'）と同じ扱いで、特殊文字や式展開が無効です。
* `%Q`：ダブルクォート（"）と同じ扱いで、特殊文字や式展開が有効です。
```ruby
name = "Ruby"
puts %q(Hello\nworld)  # => Hello\nworld（特殊文字はそのまま）
puts %Q(Hello #{name})  # => Hello Ruby（式展開が有効）
```

## `%w` と `%W`（文字列の配列）
* `%w`：スペース区切りで文字列の配列を生成します。式展開や特殊文字は解釈されません。
* `%W`：ダブルクォートと同じ扱いで、式展開や特殊文字が有効な文字列の配列を生成します。
```ruby
name = "Ruby"
p %w(apple banana cherry)  # => ["apple", "banana", "cherry"]
p %W(#{name} banana cherry) # => ["Ruby", "banana", "cherry"]
```

## `%i` と `%I`（シンボルの配列）
* `%i`：スペース区切りでシンボルの配列を生成します。式展開や特殊文字は解釈されません。
* `%I`：ダブルクォートと同様に、式展開や特殊文字が有効です。
```ruby
language = "Ruby"
p %i(apple banana cherry)  # => [:apple, :banana, :cherry]
p %I(#{language} banana cherry) # => [:Ruby, :banana, :cherry]
```
## `%r`（正規表現）
* `%r`：正規表現を簡潔に記述するために使います。特にスラッシュ / を含む正規表現を書く際に便利です。
```ruby
pattern = %r(\A\d{3}-\d{4}\z) # 文字列全体が3桁-4桁の数字と一致することを確認
puts pattern.match?("123-4567") # => true
puts pattern.match?("khasu3423532524-4239hg9h") # => false
```
## その他の%記法
* `%s`：シンボルを生成します。(通常は`:symbol`で表現します)`%i`はスペース区切りでシンボルの配列を作成するのでそこが違います。
```ruby
# %s を使った例
symbol = %s(name)      # => :name

# %i を使った例
symbols = %i(cat dog)  # => [:cat, :dog]
```

# まとめ
このようにしてみると、%記法の種類は結構多いことがわかります。
教材では`%w`と`%i`を習いましたが、これらが一番使用頻度高そうですね。
上記以外に%記法あればコメントにて教えていただけると助かります。
