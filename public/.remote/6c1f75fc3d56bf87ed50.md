---
title: 【Ruby】ファイル操作のライブラリ
tags:
  - Ruby
  - 初心者
  - File
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-01T10:58:05+09:00'
id: 6c1f75fc3d56bf87ed50
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。
こんにちは！今回は、Rubyでファイル操作を行う際に便利な標準ライブラリ、`Find`、`Tempfile`、`FileUtils`について詳しく紹介します。

# `Find` ライブラリ
Find はディレクトリを再帰的に巡回して、条件に合うファイルを見つけるためのライブラリです。大規模なディレクトリ内のファイル検索に便利です。
```ruby
require 'find'

Find.find('/path/to/directory') do |path|
  puts path if path =~ /example\.txt$/  # example.txtを見つけた場合に出力
end
```

### Find.fileの応用例
以下のファイルは特定のディレクトリを無視しながら一覧を出力するコードになります
```ruby
require "find"

IGNORES = [/^\./, /^\.svn$/, /^\.git$/]  # 無視するパターンを定義

def listdir(top)
  Find.find(top) do |path|
    if File.directory?(path)
      dir, base = File.split(path)  # ディレクトリ名とベース名を分割
      IGNORES.each do |re|
        if re =~ base  # 無視リストに一致する場合
          Find.prune  # 再帰的な検索を中断
          next
        end
      end
      puts path  # 無視されなかったディレクトリを出力
    end
  end
end

listdir(ARGV[0])  # コマンドライン引数で指定されたディレクトリを検索
```
以下はコードの解説です。
* `Find.find(top)`
このメソッドは、指定したディレクトリ（`top`）を再帰的に探索し、発見したすべてのファイル・ディレクトリのパスをブロック引数の `path` に渡します。
たとえば、`top` に `/home/user` を指定すると、`/home/user` 以下のすべてのファイルやフォルダのフルパスが順に `path` に入ります。
* `File.split(path)`
`path` をディレクトリ部分と末尾の名前（ベース名）に分割します。たとえば、`/home/user/.git` を渡した場合、`/home/user` と `.git` に分かれます。

* `IGNORES.each` と `Find.prune`
無視したいパターン（隠しファイルや `.svn`、`.git` など）に一致するかを確認し、一致した場合は `Find.prune` によりそのディレクトリの探索をスキップします。

* `puts path`
無視されなかったファイルやフォルダのパスを出力します。

# `Tempfile` ライブラリ
Tempfile はプログラムの実行中に必要な一時ファイルを簡単に作成・管理できるライブラリです。
プログラム終了時に自動で削除されるため、後処理を気にする必要がありません。
```ruby
require 'tempfile'

Tempfile.open('example') do |tempfile|
  tempfile.puts "一時データの書き込み"
  puts tempfile.path  # 一時ファイルのパスを確認
end
```
### `Tempfile`の応用例
以下は画像データを一時的に保存する例です。
```ruby
Tempfile.open(['image', '.png']) do |tempfile|
  tempfile.write(image_data)  # 画像データの一時保存
  puts "Temporary file: #{tempfile.path}"
end
```

### 利用場面
* 一時的なファイル保存：画像やPDFなどの中間データを処理する際。
* データ加工やテスト：テストコードでの一時ファイル操作にも便利です。

# `FileUtils` ライブラリ
`FileUtils` はファイルやディレクトリのコピー、移動、削除などを行うための便利なメソッドを提供するライブラリです。
シェルコマンドを使わずに同様の操作をRuby内で完結できます。
```ruby
require 'fileutils'

FileUtils.cp('source.txt', 'destination.txt')
```

### `FileUtils`の応用例
バックアップを取るコードの例を示します。
```ruby
FileUtils.cp_r('/source/directory', '/backup/directory')
puts "バックアップ完了！"
```
### 利用場面
* バックアップ処理：データの定期バックアップに使用。
* インストールスクリプト：アプリのセットアップ時にフォルダや設定ファイルを自動作成。
* ディレクトリ整備：複数のフォルダを一度に作成したり、不要なファイルを削除する場合。
# まとめ
* `Find`：ディレクトリを再帰的に巡回してファイルを検索。
* `Tempfile`：一時ファイルの作成と自動削除をサポート。
* `FileUtils`：ファイルやディレクトリの操作を簡単に。
これらのライブラリを組み合わせれば、複雑なファイル操作も効率的に行えます。
