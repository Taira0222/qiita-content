---
title: 【Ruby】エラーハンドリングのまとめ
tags:
  - Ruby
  - 初心者
  - 未経験エンジニア
  - 独学
  - エラーハンドリング
private: false
updated_at: '2024-11-07T15:15:36+09:00'
id: 62319e56c121c379fefe
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。
本日はRubyのエラーハンドリングについてまとめていきたいと思います。

プログラムを書く際、エラーが発生するのは避けられません。
エラーハンドリングを適切に行うことで、プログラムが予期しないクラッシュを回避し、ユーザーに分かりやすいメッセージを表示するなど、より安定したコードが実現できます。
Rubyのエラーハンドリングの基本を具体例を交えながら見ていきましょう。

# エラーハンドリングが必要な理由
Rubyはエラーが発生した際に原因を知らせてくれますが、それでもエラーハンドリングが重要な理由を以下のポイントに分けて解説します。

### 1. エラー発生時のカスタムメッセージの表示やログの記録
`rescue`を使うと、エラーの種類に応じてカスタムメッセージを表示したり、エラー内容をログファイルに保存できます。
特にユーザーが利用するアプリケーションでは、ユーザーに理解しやすいメッセージを表示することで、エラー内容を適切に伝えることができます。
```ruby
begin
  10 / 0
rescue ZeroDivisionError => e
  puts "エラー: 数字はゼロで割ることができません。"
  # ログファイルにエラーを記録
  File.open("error.log", "a") { |file| file.puts(e.message) }
end
```
### 2. プログラムのクラッシュ防止
エラーハンドリングがなければ、エラーが発生した時点でプログラムがクラッシュしてしまいます。
`rescue`を活用すると、エラー発生時でも特定の処理をスキップしたり、代替処理を行いながらプログラムを継続できます。
```ruby
begin
  data = File.read("non_existent_file.txt")
rescue Errno::ENOENT
  puts "ファイルが見つかりませんでした。別のファイルを指定してください。"
end
puts "プログラムはエラー後も続行します。"
```
### 3.エラーの再発防止とデバッグ効率の向上
`rescue`ブロックでエラー内容をキャッチし記録することで、後からエラーの発生原因を特定しやすくなります。
特に複雑なアプリケーションでは、エラーハンドリングによりデバッグが効率化します。

### 4. エラーによって処理を分岐させる
特定のエラーが発生した場合のみ別の処理を行うといった柔軟な制御も可能です。
たとえば、ネットワーク接続エラーが発生した場合に再試行を行うなどの処理を実装できます。
```ruby
begin
  connect_to_server
rescue NetworkError
  puts "ネットワークエラーが発生しました。再試行中..."
  retry
rescue => e
  puts "別のエラーが発生しました: #{e.message}"
end
```

# エラーハンドリング
次に、Rubyでよく使用するエラーハンドリングの基本構文について説明します。
エラーハンドリングは主に`begin`、`rescue`、`ensure`を組み合わせて使います。
```ruby
begin
  # エラーが発生する可能性のある処理
rescue => e
  # エラー発生時に行う処理
ensure
  # エラーの有無にかかわらず実行される処理
end
```
以下の例で、`ZeroDivisionError`が発生した場合に適切なメッセージを表示し、処理を続行する方法を見てみましょう。
```ruby
def divide(a, b)
  begin
    result = a / b
    puts "Result is #{result}"
  rescue ZeroDivisionError
    puts "Error: Division by zero is not allowed."
  ensure
    puts "End of calculation."
  end
end

divide(10, 2) # 正常に動作
divide(10, 0) # ゼロ割りエラーが発生
```
この例では、ゼロで割った際に`ZeroDivisionError`が発生しますが、`rescue`があるため、エラーメッセージを表示して処理を続けられます。

## 特定のエラーを捕まえる
特定のエラーだけを補足したい場合、`rescue ZeroDivisionError`のように書くことで、他のエラーには反応せず、ゼロ割りエラーのみ補足できます。
```ruby
begin
  # 読み込み専用のファイルに対して書き込みを試みる
  File.open("readonly.txt", "w")
rescue Errno::EACCES
  puts "Error: Cannot write to a read-only file."
end
```
このように、特定のエラー（ここでは`Errno::EACCES`）に対してだけ処理を行うことが可能です。

## 複数の例外をrescueで捕まえる
複数のエラーを捕まえたい場合は、rescueを重ねたり、複数の例外を配列で指定することもできます。
```ruby
begin
  # エラーが発生する可能性のある処理
rescue ZeroDivisionError, TypeError => e
  puts "An error occurred: #{e.class}"
end
```
## rescue with retryを使った再試行
`retry`を使うことで、エラーが発生した際に再度処理を実行することができます。
ネットワークエラーのように一時的な問題が起こりやすいケースで特に役立ちます。

```ruby
attempts = 0

begin
  attempts += 1
  # エラーが発生する可能性のある処理
rescue NetworkError => e
  if attempts < 3
    puts "Retrying... (Attempt #{attempts})"
    retry
  else
    puts "Failed after 3 attempts."
  end
end
```

## `ensure`で必ず実行される処理を記述する
`ensure`は、エラーの発生有無に関わらず必ず最後に実行されます。
ファイルやネットワーク接続など、リソースの解放が必要な場面で利用すると便利です。
```ruby
file = File.open("sample.txt", "w")

begin # エラーが発生する可能性のある処理
  file.puts "Hello, World!"
rescue IOError => e # エラー発生時に行う処理
  puts "An IOError occurred: #{e.message}"
ensure # エラーの有無にかかわらず実行される処理
  file.close
  puts "File closed."
end
```

# まとめ
エラーハンドリングを適切に行うことで、プログラムの安定性やデバッグの効率が向上します。特に重要なポイントは以下の通りです

* エラー時のカスタムメッセージ表示
ユーザーに分かりやすいメッセージを表示し、エラー内容をログに記録する。
* プログラムのクラッシュ防止
エラー発生時に処理をスキップし、代替処理でプログラムを継続する。
* リソース管理のための`ensure`
リソースのクローズや解放を確実に行うために使用する。
一時的なエラーに対する再試行
`retry`を使って、特定のエラーが発生した際に数回まで再試行する。

この記事を通して、エラーハンドリングの基本と実践的な使用法について理解が深まったでしょうか？
適切なエラーハンドリングを習得し、より堅牢なコードを書けるように頑張りましょう！
