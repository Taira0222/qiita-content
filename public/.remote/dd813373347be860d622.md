---
title: 【Ruby】putsと$stdout.putsの違い
tags:
  - Ruby
  - 初心者
  - io
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-11-22T15:14:37+09:00'
id: dd813373347be860d622
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。
本日は`puts`と`$stdout.puts`の違いについて説明していきたいと思います。
Rubyを使っているとき、よく目にする `puts`。そしてあまり見かけない `$stdout.puts`。
これらはどちらも「標準出力」に文字列を出力するために使われますが、実は微妙な違いがあります。
それぞれ見ていきましょう。

## `puts` とは
`puts` は、Rubyで最も基本的な出力メソッドの一つです。現在の `$stdout` に文字列を出力します。
通常、Rubyプログラムを実行したときの「標準出力」とはターミナルの画面を指します。

以下の例を見てください。
```ruby
puts "Hello, World!" # ターミナルに "Hello, World!" を表示
```
この場合、`puts` はデフォルトでターミナル（`STDOUT`）に「Hello, World!」と出力します。

## `$stdout.puts` とは
`$stdout` は、Rubyにあらかじめ定義されているグローバル変数で、現在の標準出力を指します。
`$stdout.puts` は、この `$stdout` オブジェクトに対して直接 `puts` を呼び出す形式です。

以下は `puts` と `$stdout.puts` の基本的な使い方です。

```ruby
puts "Hello, World!"        # ターミナルに "Hello, World!" を表示
$stdout.puts "Hello, World!" # 同じ結果を表示
```
動作は似ていますが、両者の違いは `$stdout` をリダイレクト（出力先を変更）したときに顕著になります。

## 違いが出るケース：`$stdout` のリダイレクト
#### リダイレクトとは？
リダイレクトとは、標準出力の出力先を変更することです。
通常、`puts` はターミナル画面に出力されますが、リダイレクトを使うとターミナル以外の場所（例: ファイルや仮想ファイル）に出力を切り替えることができます。

具体例を見てみましょう。
```Ruby

require 'stringio'

# ログ用の仮想ファイルを用意
log = StringIO.new

# $stdout をリダイレクト
$stdout = log

# 出力を確認
puts "This is puts"
$stdout.puts "This is $stdout.puts"

# $stdout を元に戻す
$stdout = STDOUT

# 結果の確認
puts "Log contents:"
puts log.string
```
実行結果
```ruby
Log contents:
This is puts
This is $stdout.puts
```

### コードの動作解説
1. $stdout を仮想ファイルにリダイレクト
`$stdout = log` で `$stdout` を仮想ファイル（`StringIO` オブジェクト）にリダイレクトしています。この時点から、`puts` の出力先がターミナルではなく仮想ファイルになります。

2. `puts` の動作
`puts` は `$stdout` を経由するため、現在の `$stdout`（仮想ファイル）に "This is puts" を書き込みます。

3. `$stdout.puts` の動作
`$stdout.puts` は `$stdout` オブジェクトの `puts` メソッドを直接呼び出して、仮想ファイルに "This is $stdout.puts" を書き込みます。

4. `$stdout` を元に戻す
`$stdout = STDOUT` で `$stdout` を標準の出力先（ターミナル）に戻します。

5. ログ内容を確認
仮想ファイル（log）に蓄積された内容を `log.string` で取得し、ターミナルに出力します。

## リダイレクトなしの場合
リダイレクトを行わない場合の動作を確認してみましょう。

```Ruby
puts "This is puts"
$stdout.puts "This is $stdout.puts"
```
出力結果
```ruby
This is puts
This is $stdout.puts
```

この場合、`puts` と `$stdout.puts` のどちらもデフォルトの `$stdout`（STDOUT オブジェクト）を通じてターミナルに直接出力されるため、記述された順番通りに表示されます。

### `$stdout` を操作するメリット
では、わざわざ `$stdout` を操作して出力先を変更するメリットは何でしょうか？
以下に `$stdout` のリダイレクトが役立つ具体例を示します。

#### テストやデバッグに活用
たとえば、プログラムの動作確認やログ収集のために出力内容を一時的にログとして保存したい場合、以下のように `$stdout` をリダイレクトすると便利です。

```ruby
require 'stringio'

log = StringIO.new
$stdout = log

puts "Test log: Something happened."
$stdout = STDOUT

puts "Captured log:"
puts log.string
```
出力結果

```ruby
Captured log:
Test log: Something happened.
```
仮想ファイルに出力を切り替えることで、テストの動作確認やデバッグの効率を向上させられます。

# まとめ
* `puts` と `$stdout.puts` は通常同じ挙動ですが、リダイレクトを行うと違いが顕著になります。
* `$stdout` をリダイレクトすることで、出力先を仮想ファイルや別のストリームに柔軟に切り替えることが可能です。
* テストやログ収集の際に `$stdout` を操作することで、プログラムの動作確認やデバッグを効率化できます。
注意点として、リダイレクトは一時的な変更であるため、必ず元の `$stdout`（`STDOUT`）に戻すことを忘れないようにしましょう！
