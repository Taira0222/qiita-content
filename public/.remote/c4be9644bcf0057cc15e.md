---
title: 【Ruby】標準入出力まとめ
tags:
  - Ruby
  - 初心者
  - io
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-11-23T13:43:28+09:00'
id: c4be9644bcf0057cc15e
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。
本日は、Ruby の `$stdin`、`$stdout`、$`stderr` について解説していきたいと思います。

前回標準出力の内容についての記事を書きましたが、標準入力と標準エラー出力についても同要にまとめておこうと思ったので記事にしました。


## `$stdin` とは？
`$stdin` は Ruby における標準入力を表すグローバル変数です。
通常、この標準入力は キーボード入力 を指します。

例えば、`gets` メソッドを使った入力取得は、デフォルトで `$stdin` を利用しています。

```ruby
puts "Enter your name:"
name = $stdin.gets.chomp
puts "Hello, #{name}!"
```

実行例
```Ruby
Enter your name:
Ruby
Hello, Ruby!
```
## `$stdout` とは？
`$stdout` は Ruby における標準出力を表すグローバル変数です。通常、この標準出力は ターミナル を指します。

Ruby の `puts` や `print` メソッドは、デフォルトで $stdout に出力します。以下の例を見てみましょう
```ruby
puts "Hello, World!"          # ターミナルに出力
$stdout.puts "Hello, Ruby!"   # 同じくターミナルに出力
```

## `$stderr` とは？
`$stderr` は Ruby における標準エラー出力を表すグローバル変数です。
通常、この標準エラー出力も ターミナル を指しますが、`$stdout` とは異なるストリームとして扱われます。

エラーメッセージを出力する際に、`$stderr.puts` を使用します。

```ruby
$stderr.puts "This is an error message."
```


## $stdin、$stdout、$stderr と通常のメソッドの違い
### 通常のメソッド
Ruby では、標準入出力やエラー出力を行う際に次のようなメソッドがよく使われます。

* `gets`: 標準入力（$stdin）から1行を取得します。
* `puts`: 標準出力（$stdout）に文字列を出力します。
* `warn`: 標準エラー出力（$stderr）にメッセージを出力します。
これらのメソッドは デフォルトで $stdin、$stdout、$stderr を操作 します。

```ruby
puts "Hello, World!"   # 実際には $stdout.puts("Hello, World!") と同等
gets                   # 実際には $stdin.gets と同等
warn "An error!"       # 実際には $stderr.puts("An error!") と同等

```
## `$stdin` などの直接操作の利点
`$stdin`、`$stdout`、`$stderr` を直接操作すると、リダイレクトやカスタマイズが可能になります。
例えば、入力元や出力先を変更することでテストやログの記録を簡単に行えます。

### `$stdin` のリダイレクト例
標準入力の入力元をファイルや仮想入力に変更できます。
以下は、`StringIO` を使って仮想入力を設定する例です

```ruby
require 'stringio'

# 仮想入力を用意
input = StringIO.new("Hello, World!")

# $stdin をリダイレクト
$stdin = input

# 入力を取得
user_input = gets.chomp
puts "You entered: #{user_input}"

# 元に戻す
$stdin = STDIN
```
実行結果は以下の通りです
```ruby
You entered: Hello, World!
```

### `$stdout` のリダイレクト例
標準出力の出力先を変更することで、出力内容をファイルやメモリ上に記録できます。

```ruby
require 'stringio'

# 仮想ファイルを用意
log = StringIO.new

# $stdout をリダイレクト
$stdout = log

# 出力内容
puts "Logging this message."

# 元に戻す
$stdout = STDOUT

# ログ内容を確認
puts "Log contents:"
puts log.string
```
実行結果は以下の通りです。
```ruby
Log contents:
Logging this message.
```

### `$stderr` のリダイレクト例
標準エラー出力の出力先も変更できます。以下はエラー出力をファイルに記録する例です

```ruby
require 'stringio'

# 仮想ファイルを用意
error_log = StringIO.new

# $stderr をリダイレクト
$stderr = error_log

# エラーメッセージを出力
$stderr.puts "This is an error."

# 元に戻す
$stderr = STDERR

# エラーログ内容を確認
puts "Error log contents:"
puts error_log.string
```
実行結果は以下の通りです。
```ruby
Error log contents:
This is an error.
```

## 実用例：入出力とエラーを同時にリダイレクト
すべてのストリームをリダイレクトしてログを収集する例です

```ruby
require 'stringio'

# 仮想的な入出力・エラー出力を用意
input = StringIO.new("Test Input")
output_log = StringIO.new
error_log = StringIO.new

# リダイレクト
$stdin = input
$stdout = output_log
$stderr = error_log

# 処理内容
puts "Processing input..."
user_input = gets.chomp
puts "You entered: #{user_input}"
$stderr.puts "Warning: This is a simulated error."

# 元に戻す
$stdin = STDIN
$stdout = STDOUT
$stderr = STDERR

# ログ内容を確認
puts "Standard Output Log:"
puts output_log.string
puts "Standard Error Log:"
puts error_log.string
```

実行結果は以下の通りです
```ruby
Standard Output Log:
Processing input...
You entered: Test Input

Standard Error Log:
Warning: This is a simulated error.
```
# まとめ
`$stdin`、`$stdout`、`$stderr` はそれぞれ標準入力、標準出力、標準エラー出力を表すグローバル変数です。
デフォルトでは、`$stdin` はキーボード入力、`$stdout` はターミナル、`$stderr` はターミナルのエラー出力を指します。
リダイレクトを活用することで、入力元や出力先を柔軟に変更可能です。
リダイレクト後は、必ず元に戻すことを忘れないようにしましょう！
