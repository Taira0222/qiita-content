---
title: 【Ruby】requireとrequire_relativeの違い
tags:
  - Ruby
  - Require
  - 未経験エンジニア
  - 未経験からWeb系
private: false
updated_at: '2024-10-21T15:10:15+09:00'
id: 30b3941c050d188b7cf5
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは、Ruby絶賛勉強中のものです。
「たのしいRuby」という書籍を使用して勉強しているのですが、そこで`require`と`require_relative`についての説明がありました
`require`は既存のライブラリを読み込むときに使用し、`require_relative`は相対パスの際に使用する旨が書いてありました。
外部ライブラリや絶対パスの場合について言及されていなかったので詳しく調べてみました。

環境：`Ruby 3.3.5`

# `require`とは
`require` は、指定したライブラリやファイルを読み込む際に使います。
`require` を使う場合、通常はRubyのライブラリの検索パス (`$LOAD_PATH`(後に説明します) もしくは `$:` として参照される) から指定されたファイルを検索します。
また、ファイルパスは<strong>絶対パスまたは `$LOAD_PATH` </strong>に基づいて検索されます。

続いてどのような場面で使用されるのでしょうか。
* Ruby標準ライブラリや、Gemなどの外部ライブラリを読み込む際に使用。
* 明示的に絶対パスを使ってファイルを指定する場合にも使用される。
本書で言及のなかった外部ライブラリや絶対パスの場合は`require`を使用するということです

```ruby:req1.rb
require 'date'      # Ruby標準ライブラリ
require 'json'       # 外部ライブラリ（Gemなど）
require '/path/to/file' # 絶対パスでファイルを読み込む
```

### `$LOAD_PATH`とは？
さらっと出てきた`$LOAD_PATH`とは何者なのでしょうか。
Rubyはファイルを読み込む(`require`など)際に、ある特定のディレクトリを検索します。
この検索するディレクトリのリストを`$LOAD_PATH`（もしくは`$:`）と呼びます。
`require`を使うと、この`$LOAD_PATH`に含まれるディレクトリを検索し、指定したファイルを見つけて読み込みます。

例えば、`$LOAD_PATH`に以下のようなディレクトリが含まれている場合を考えます
```ruby:
["/usr/local/lib/ruby/site_ruby", "/usr/local/lib/ruby/vendor_ruby", "/usr/lib/ruby/2.7.0"]
```
ここに存在するファイルであれば、ファイル名だけを指定してrequireで読み込むことができます。
```ruby
require 'mylibrary'
```

すでに`Linux`を勉強している方ならわかるかもしれませんが、この仕組みは`Linux`の `PATH` 環境変数と似ています。

`Linux`では、例えば `ls` コマンドを実行すると、システムは `PATH` にリストされたディレクトリの中から `ls` の実行ファイルを探します。
Rubyでは、`require 'mylibrary'` と書くと、Rubyは `$LOAD_PATH` にリストされたディレクトリから `mylibrary` という名前のファイルを探してロードします。

# `require_relative` の特徴
`require_relative` は、指定したファイルを <strong>現在のファイルの相対パス</strong> で読み込む際に使用します。
これにより、`require_relative` は、現在のファイルと同じディレクトリやサブディレクトリにあるファイルを簡単に読み込むことができます。
`require_relative`は以下の場面で使用されます。
* 自分のプロジェクト内のファイルを、現在のファイルの場所を基準にして読み込みたいときに使う。
* 小規模なプロジェクトや、複数のファイルが同じディレクトリ内またはディレクトリ階層にある場合に便利。
1つ目は本書に書いてあった相対パス指定するということ、2つ目は1つ目の特徴を生かした特徴です。

```ruby
require_relative 'my_class'         # 現在のファイルと同じディレクトリ内の my_class.rb を読み込む
require_relative '../utils/helper'  # 1つ上のディレクトリにある helper.rb を読み込む
```

# まとめ
本日は`require`と`require_relative`について特徴や違いについて説明しました。
`require`は標準ライブラリや外部ライブラリ（Gem）を読み込む場合や、絶対パスを使う場合に使用。
`require_relative`は相対パスで自作のファイルを読み込む場合に使用。
と覚えておきましょう。
内容に誤りやこの表現のほうがいいよというアドバイスがありましたら、コメントお待ちしております。
