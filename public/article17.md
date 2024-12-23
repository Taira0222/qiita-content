---
title: 【Ruby】getsメソッドとchompの使い方について
tags:
  - Ruby
  - 未経験エンジニア
  - chomp
  - 未経験からWeb系
private: false
updated_at: '2024-10-21T14:15:30+09:00'
id: 4ac528abe63dde5b2893
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは、今回はRubyのgetsメソッドとchompメソッドについてお話します。
この2つのメソッドは、ユーザーからの入力を処理するときによく使われますが、意外と知られていない細かい部分もあるので記事にしようと思いました

# `gets`メソッドとは
まずは基本的な`gets`メソッドの解説をしていきます
`gets`メソッドは、ユーザーの入力を受け取るためのメソッドです。プログラムが実行されると、キーボードから入力を受け取り、その値を文字列として返します。下の例を見てみましょう。
```ruby:gets1.rb
input = gets
puts "あなたが入力したのは: #{input}です"

# （入力）こんにちは
# あなたが入力したのは：こんにちは
# です
```
このコードを実行すると、コンソール上で入力を待ちます。例えば「こんにちは」と入力してEnterキーを押すと、上記のように表示されます。
本来であれば、「あなたが入力したのは: こんにちはです」のように出力したいのですが、`gets`のみの場合だとこんにちはのうしろに改行(`\n`)が入ります。

# `gets`が改行コードを含む理由
このように改行をするケースのほうが少ないのにどうして入力内容の後に改行(`\n`)が入るのでしょうか。すこし深堀してみましょう
ここで注意すべき点は、`gets`メソッドは入力値と一緒に改行コード（\n）も含めて返すということです。
`gets`での入力後、コンソール上でEnterキーを押すと、入力された文字列に改行が自動的に追加されるのです。実際に次のようなコードで確認できます。
```ruby:gets2.rb
input = gets
p input
# （入力）こんにちは
# "こんにちは\n"
```
改行コードが含まれるのは、入力が完了したことを示すEnterキーが押されたタイミングで、それも入力として扱われるからです。
しかし、ほとんどのケースでは改行をそのまま使いたくない場合が多いです。

# `chomp`メソッドとは？
そこで登場するのが、`chomp`メソッドです。
`chomp`メソッドは、文字列から末尾の改行コード（`\n`）を取り除くメソッドです。`gets`で入力されたデータをきれいにしたいときに非常に便利です。

```ruby:gets3.rb
input = gets.chomp
puts "あなたが入力したのは: #{input}です"

# （入力）こんにちは
# あなたが入力したのは：こんにちはです
```
多くの場合、入力された値をそのまま使うケースが多いため`gets`と`chomp`を合わせて使うケースが多く、単体ではなく合わせて覚えている人も多いのではないでしょうか。


# まとめ
* `gets`はユーザーの入力を取得するためのメソッドであり、入力に改行が含まれる。
* `chomp`メソッドを使うことで、`gets`で取得した文字列から改行を取り除くことができる。
* `gets.chomp`の組み合わせは、入力を扱うときの標準的なパターン。

このように、`gets`と`chomp`の組み合わせを使うことで、ユーザーからの入力を適切に処理できます。


