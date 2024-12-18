---
title: 【Ruby】irbとbinding.irbとは
tags:
  - Ruby
  - 初心者
  - irb
  - 未経験エンジニア
  - binding.irb
private: false
updated_at: '2024-11-03T14:39:06+09:00'
id: 64bfcccbf66d207473e9
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！現在アメリカの大学で語学を学びながら、ソフトウェアエンジニアを目指して独学しているものです。
本日は、Rubyでデバッグに使われる `irb` と `binding.irb` について詳しく解説していきます。実務で使われる機会が多いかはわかりませんが、`irb`は教材でよく登場する基本的なツールですので、使い方を知っておいて損はありません。

# `irb`とは
`irb`（Interactive Ruby）は、Rubyの対話型シェルです。
対話型シェルとは、ターミナル（黒い画面）に入力された内容をすぐに実行し、結果を表示する環境のことです。
`irb`ではRubyコードを1行ずつ実行し、即座に結果を確認できるため、コードの学習や動作確認、デバッグにとても役立ちます。

通常のプログラム実行では、コードエディタ（例：`Visual Studio Code`など）でスクリプトを書き、コマンドラインでファイルを指定して実行しますが、`irb`ではターミナル上で直接Rubyコードを入力し、結果をその場で確認できます。

### `irb`の基本的な使い方
ターミナルで次のコマンドを入力すると、`irb`が起動します。
```bash
$ irb
```
起動後、以下のようなプロンプトが表示され、コードを入力してEnterキーを押すと即座に結果が出力されます。

```ruby
irb(main):001:0> puts "Hello, Ruby!"
Hello, Ruby!
=> nil
```
`=> nil` は、`puts`メソッドの返り値が `nil` であることを示しています。
また、`irb(main):001:0>` というプロンプトは、`irb`の行番号を示しています。

`irb`を終了するには、`exit` または `quit` と入力します
Windowsの場合は`Ctrl`と`d`でも同様に終了することができます。
```ruby
irb(main):002:0> exit
```

# `binding.irb`とは
`binding.irb `は、プログラムの任意の場所で`irb`セッションを開始するメソッドです。
コードの途中に `binding.irb` を挿入すると、その場所で実行が一時停止し、周囲の変数やメソッドの状態を確認できるようになります。
特にデバッグの際に便利で、変数の値や計算の結果をその場でチェックすることが可能です。

```ruby:debug.rb
sum = 0 
outcome = {"参加費" => 1000, "ストラップ代" => 1000, "懇親会会費" => 4000}
outcome.each do |pair|
    sum += pair[1]
    binding.irb  # ここで実行を一時停止して、sumやpairの状態を確認できる
end
puts "合計 : #{sum}"
```
このコードの例で言うと、`outcome`ハッシュの中身を`each`メソッドで1要素ずつ処理し、`binding.irb`の位置で実行を一時停止できます。
1回目の繰り返しでの `pair` の値は` ["参加費", 1000] `で、`pair[1]`には`1000`が代入され、これが`sum`に加算されます。

`binding.irb`があると、その場でコードを検証でき、変数の値や状態を即座に調べられます。
```ruby:bind.rb
# 実行時のイメージ
　1: sum = 0 
　2: outcome = {"参加費" => 1000, "ストラップ代" => 1000, "懇親会会費" => 4000}
　3: outcome.each do |pair|
　4:     sum += pair[1]
=>5:     binding.irb
　6: end
　7: puts "合計 : #{sum}"

irb(main):001> sum # binding.irbで止まっている状態
=> 1000
irb(main):002> pair[0]
=> "参加費"
irb(main):003> exit

```
なお、この例は`each`ブロック内で`binding.irb`が3回実行されるため、exitを3回入力する必要があります。`Ctrl + D`でも同様に終了可能です。

もしデバッグでコードを止めたくない場合は、単に`puts`で確認する方法もあります。
```ruby
sum = 0 
outcome = {"参加費" => 1000, "ストラップ代" => 1000, "懇親会会費" => 4000}
outcome.each do |pair|
    sum += pair[1]
    puts "#{pair[0]}は#{pair[1]}円です"
end
puts "合計 : #{sum}"

# 出力例:
# "参加費は1000円です"
# "ストラップ代は1000円です"
# "懇親会会費は4000円です"
# "合計 : 6000円"
```

# まとめ
`irb`はRubyの対話型シェルで、リアルタイムでコードの動作確認ができる便利なツールです。さらに、`binding.irb`を使うことで、プログラムの任意の箇所で実行を一時停止し、変数や計算の結果を確認できます。
