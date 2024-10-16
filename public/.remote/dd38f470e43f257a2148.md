---
title: 【Git】Qiita CLIを使う
tags:
  - Git
  - GitHub
  - 未経験エンジニア
  - QiitaCLI
private: false
updated_at: '2024-10-16T23:53:31+09:00'
id: dd38f470e43f257a2148
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは、10/6から毎日投稿(時差があるため若干ずれているものもあります）してます。
アウトプットする内容がなくならないように、インプットも頑張ります。
最近`Qitta`でブログを投稿するようになり、投稿のボタンを押すたびに「`Github`で記事を管理する」が目に入っていたので`Git`の基礎を学んだら使ってみようと思いました。
そこで今回はすでに`Qiita CLI`を使っている方やこれから使う方に向けて、いろいろ書いていこうと思います。

環境:
OS:`windows 11`
Terminal:`Gitbash`
`Node.js -v 20.18.0`
    

# Qiita CLIとは
`Qiita CLI`を使うと以下のことができます。
* CLI操作で`Qiita`の投稿を自分の指定したディレクトリに保存することができる
* CLI上で記事の投稿ができる（削除はできない）
という感じです。
つまり、`Qiita`を一種のリモートデポジトリのように扱える機能っていえばいいんですかね、？
詳しい`Qiita CLI`のセット方法は[こちら](https://qiita.com/Qiita/items/32c79014509987541130)から

# Qiita CLIを使用するメリット
私の思うメリットは以下の通りです
* 記事の作成をオフライン上でできる
* CLIのほうが操作が楽
* カレントディレクトリに保存できるようになるため、`GitHub`のデポジトリに記事を保存できる
* `Git`の練習になる(未経験の方向け)
* `GitHub`の草をはやすことできる
* CLI操作で投稿できるのなんかかっこよくないですか...?
`GitHub`の`contributeをすると緑色がつくので草をはやすというらしいです。
こんなにメリットがあるので試すほかありませんよね？

# Qiita CLIを使用する上で知っておいた方がいいこと
これについては知らなかったというか、操作しながら学んだので共有したいと思います。
結論から書いておくと、ファイル名を変える場合は`.remote`ファイルの中をまったくいじらないでおきましょう。
`npx qiita publish ファイル名`を実行した際に、`.remote`ファイルの更新をするのですが、もとのファイル名でないと、変更したファイル＋煩わしい名前のファイルが保存されるよくわからない状態になります。
`.remote`は放置と覚えておきましょうｗ

そんなこと知ってるよ！って方はスルーで大丈夫ですが、煩わしくよくわからないファイル名を変えるシェルスクリプトも載せているのでよかったら見てください。

`npx qiita new ファイル名`で投稿する記事のファイルを作成することができます
例えば
```
npx qiita new article1
# カレントディレクトリ内にarticle1.mdが作成される
```
という感じです。
上記の`Qiita CLI`の`README`を作成しながら進めると、投稿したファイルをカレントディレクトリに以下のように作成します。
すでに投稿しているファイルが2つの場合こんな感じで作成されます。
```
public--
       |_.remote
       |_rejkjflkajlkdfja.md
       |_djfalkjflkajdflk.md
```
ここで`.remote`について、いくつか注意点がありますが隠しファイルなので触らないと覚えておきましょう。
ここで、私はファイル名が長すぎて嫌だったので投稿順に`article1.md`のように名前を付けようと考えました。

ここで正直に言うと`chatgpt`の力を借りて、以下のシェルスクリプトを作成し名前を変更しました。(ここ以降の話は`Linux`知らないときついかも...)
同じ共有の方もいると思うので参考にしてもらえれば幸いです。
```:rename_md_files.sh
#!/bin/bash

# 1. 日付をファイルから取得して、ファイル名と共に保存
declare -A file_dates

for file in *.md; do
    # 正確な 'updated_at' 行を取得
    date=$(grep "^updated_at: " "$file" | sed -E "s/updated_at: '(.*)T.*'/\1/")
    
    if [ -n "$date" ]; then
        file_dates["$file"]="$date"
        echo "Found date $date in file $file"
    else
        echo "No date found in file $file"
    fi
done

# 2. 日付順にソートしてリネーム
count=1
for file in $(for key in "${!file_dates[@]}"; do echo "${file_dates[$key]} $key"; done | sort | awk '{print $2}'); do
    echo "Renaming $file to article$count.md"
    mv "$file" "article$count.md"
    count=$((count + 1))
done

echo "ファイルが順番にリネームされました。"
```
`rename_md_files.sh`をカレントディレクトリに保存して、以下のコマンドを実行します
```
$ ./rename_md_files.sh
# 実行権がありません的なのが出てくる
$ chmod a+x ./rename_md_files.sh
$ ls -l
# rwxr-xr-x ....と記載がある。xは実行権を付与したという意味
$ ./rename_md_files.sh
```
これで名前が変わっているはずなので試してみてください。
`Bash`を使えばいきなり実行できますが、誤って操作をしてしまうリスクがあると習ったので勉強のため`chmod`を用いて実行します。
という感じでファイル名も変えて、`.remote`を放置すればあとは`git`を使って自分の`GitHub`に`push`するだけです。
ちなみに、GitHubに載せる際に`rename_md_files.sh`を載せたくない方は`gitignore`に記載を忘れずに。

私のようなプログラミングスクールに行かず独学の人にとって、`git`を触るいい機会だと思います。
私の場合は、`branch`を作成して`pull request`やもう一つアカウントを作って`コメント`や`merge`など勉強していますw

