---
title: 【勉強記録】Qiita自動投稿＆X自動ポストシステムをGitHub Actionsを使って再現してみた part2
tags:
  - Ruby
  - 初心者
  - 未経験エンジニア
  - 独学
  - GitHubActions
private: false
updated_at: '2025-03-03T11:53:20+09:00'
id: a805dcac364112d1fc6e
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。私はアメリカ在住で、独学によりエンジニアを目指している者です。
以前の記事でも触れた通り、Qiitaに投稿すると同時にGitHubにも反映されるスクリプトと、Linuxで学んだcronの仕組みを組み合わせることで、Qiitaへの投稿を自動化できるのではないか？という仮説のもと調査を進めました。調べた結果、GitHub Actionsを用いれば実現可能であることが分かったので、実際に作成してみました。
今回は、使用したymlファイルと、QiitaおよびGitHubへpushするスクリプトについて解説します。

---

## 今回使用したymlファイル

今回使用したymlファイルは以下の通りです。

```yml
name: Publish Article and Post to X

on:
  schedule:
    - cron: '0 2 * * *'  # 日UTC 02:00に実行＝Americaの時間19:00に実行するように変更
  workflow_dispatch:

jobs:
  publish:
    runs-on: ubuntu-latest
    env:
      QIITA_TOKEN: ${{ secrets.QIITA_TOKEN }}
    steps:
      - name: Checkout current repository
        uses: actions/checkout@v3

      - name: Checkout qiita-content repository
        uses: actions/checkout@v3
        with:
          token: ${{ secrets.MY_PAT }}
          path: qiita-content

      - name: Checkout refuge_qiita repository
        uses: actions/checkout@v3
        with:
          repository: Taira0222/refuge_qiita
          token: ${{ secrets.MY_PAT }}
          ref: main
          path: refuge_qiita

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3.5'

      - name: Install qiita-cli
        run: npm install -g @qiita/qiita-cli@latest
        shell: bash

      - name: Configure Git
        run: |
          git config --global user.name "GitHub Actions"
          git config --global user.email "actions@github.com"

      - name: Run Publish Article Script
        env:
          QIITA_TOKEN: ${{ secrets.QIITA_TOKEN }}
        run: ruby scripts/publish_article.rb
        shell: bash

      - name: Upload Published URL Artifact
        uses: actions/upload-artifact@v4
        with:
          name: published-url
          path: qiita-content/published_url.txt

      - name: Upload Published Title Artifact
        uses: actions/upload-artifact@v4
        with:
          name: published-title
          path: qiita-content/published_title.txt

  post_to_x:
    needs: publish
    runs-on: ubuntu-latest
    steps:
      - name: Checkout current repository
        uses: actions/checkout@v3
        
      - name: Download Published URL Artifact
        uses: actions/download-artifact@v4
        with:
          name: published-url
          path: published

      - name: Download Published Title Artifact
        uses: actions/download-artifact@v4
        with:
          name: published-title
          path: published_title

      - name: Read Published URL
        id: read_url
        run: |
          published_url=$(cat published/published_url.txt)
          echo "Published URL is: $published_url"
          echo "published_url=$published_url" >> $GITHUB_OUTPUT

      - name: Read Published Title
        id: read_title
        run: |
          title=$(head -n 1 published_title/published_title.txt)
          echo "Extracted title: $title"
          echo "title<<EOF" >> "$GITHUB_OUTPUT"
          echo "$title" >> "$GITHUB_OUTPUT"
          echo "EOF" >> "$GITHUB_OUTPUT"        

      - name: Set up Ruby for X API posting
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3.5'
        
      - name: Install x-ruby gem
        run: gem install x

      - name: Post tweet using x-ruby
        env:
          TWITTER_CONSUMER_KEY: ${{ secrets.TWITTER_CONSUMER_KEY }}
          TWITTER_CONSUMER_SECRET: ${{ secrets.TWITTER_CONSUMER_SECRET }}
          TWITTER_ACCESS_TOKEN_KEY: ${{ secrets.TWITTER_ACCESS_TOKEN_KEY }}
          TWITTER_ACCESS_TOKEN_SECRET: ${{ secrets.TWITTER_ACCESS_TOKEN_SECRET }}
          TWEET_TITLE: ${{ steps.read_title.outputs.title }}
          TWEET_URL: ${{ steps.read_url.outputs.published_url }}
        run: ruby scripts/post_x.rb
        shell: bash
```

最初はymlファイルを2つに分割して実装していましたが、QiitaのURLや記事タイトルの受け渡しがうまくいかず、1つに統合することにしました。

なお、`post_to_x`ジョブは内容が長くなりそうなので、今回は`publish`ジョブに着目して解説します。`publish`ジョブの注目すべきポイントは以下の通りです。

- **Qiita CLIの利用:** Qiita CLIの実行に必要な`QIITA_TOKEN`を環境変数として設定しています。
- **プライベートリポジトリへのアクセス:** PAT（Personal Access Token）を用いて、プライベートリポジトリにもアクセスできるようにしています。
- **各種セットアップ:** Node.jsとRubyのセットアップ、及びQiita CLIのインストール処理が含まれています。
- **スクリプト実行:** `publish_article.rb`を実行して記事の投稿処理を開始しています。
- **成果物のアップロード:** Qiita CLIで記事投稿した際に生成される情報（URL、記事タイトル）をアーティファクトとして保存し、後続ジョブに引き渡しています。

また、`secrets.QIITA_TOKEN`のように`secrets`付きの変数は、GitHub上で事前に設定する必要があります。手順は以下の通りです。

1. GitHub Actionsを実行するリポジトリにアクセスする
2. 「Settings」を開き、左側の「Secrets and variables」をクリックした後、表示される「Actions」を選択する
3. 「New repository secret」をクリックし、Qiitaの場合はQiitaのトークンを入力する

---

## 使用したスクリプト

以下は、QiitaとGitHubへpushするためのRubyスクリプトです。

```ruby
#!/usr/bin/env ruby
require 'time'
require 'fileutils'

# 対象期間を2025/02/05 ～ 2025/03/11に設定
america_time = Time.now.getutc - (7 * 3600)
start_date = Time.parse("2025-02-05 19:00:00") # スタート時刻の変更
end_date   = Time.parse("2025-03-11 19:00:00") # エンド時刻の変更
unless america_time >= start_date && america_time <= end_date
  puts "現在の America 時刻 (#{america_time}) は実行期間外です。終了します。"
  exit 0
end

qiita_github_dir = File.join(Dir.pwd, 'qiita-content')
public_dir       = File.join(qiita_github_dir, 'public')
refuge_dir       = File.join(Dir.pwd, 'refuge_qiita')

# Step 1: refuge_qiita 内の最小番号の stock*.md ファイルを選択する
stock_files = Dir.entries(refuge_dir).select { |f| f =~ /^stock(\d+)\.md$/ }
if stock_files.empty?
  puts "refuge_qiita 内に対象ファイルが見つかりません。"
  exit 1
end
smallest_file = stock_files.sort_by { |f| f.match(/^stock(\d+)\.md$/)[1].to_i }.first
puts "Moving file: #{smallest_file}"
source_path = File.join(refuge_dir, smallest_file)
dest_path   = File.join(public_dir, smallest_file)
FileUtils.mv(source_path, dest_path)

# Step 5: refuge_qiita 側で、stock ファイルの削除内容をコミット＆push
Dir.chdir(refuge_dir) do
  puts "Committing deletion of #{smallest_file} in refuge_qiita"
  system("git add -A")
  commit_msg = "Remove #{smallest_file} after moving to qiita-content/public"
  system("git commit -m \"#{commit_msg}\"")
  system("git push")
end

# Step 2: qiita-content/public 内の article*.md ファイルから最大番号を取得し、新しい記事番号を決定する
article_files = Dir.entries(public_dir).select { |f| f =~ /^article(\d+)\.md$/ }
if article_files.empty?
  puts "qiita-content/public 内に article ファイルが見つかりません。"
  exit 1
end
max_article_num = article_files.map { |f| f.match(/^article(\d+)\.md$/)[1].to_i }.max
new_article_num = max_article_num + 1
new_file_name   = "article#{new_article_num}.md"
new_file_path   = File.join(public_dir, new_file_name)
puts "Renaming moved file to: #{new_file_name}"
FileUtils.mv(dest_path, new_file_path)

# Step 3: 新しい記事ファイルからタイトルを抽出し、published_title.txt に保存
begin
  article_content = File.read(new_file_path)
  title_line = article_content.lines.find { |line| line.strip.start_with?("title:") }
  title = title_line ? title_line.sub(/^title:\s*/, "").strip : ""
  puts "Extracted title: #{title}"
  File.write(File.join(qiita_github_dir, "published_title.txt"), title)
rescue => e
  puts "Error extracting title: #{e}"
  title = ""
end

# Step 4: Qiita CLI を使用して記事を投稿する
Dir.chdir(qiita_github_dir) do
  publish_cmd = "npx qiita publish article#{new_article_num}"
  puts "Running command: #{publish_cmd}"
  cli_output = `#{publish_cmd}`.strip
  puts "CLI output: #{cli_output}"

  # 例: "Posted: article131 -> b1d868005ebc79600fc7"
  article_id = cli_output.split("->").last.strip
  published_url = "https://qiita.com/Taira0222/items/#{article_id}"

  # 万が一複数行出力される場合、最初の行のみを使用する
  clean_url = published_url.split("\n").first.strip
  puts "Published URL: #{clean_url}"
  File.write("published_url.txt", clean_url)

  # GitとGitHubに変更を反映させる
  puts "Running command: git add -A"
  system("git add -A")
  commit_msg = "Add article#{new_article_num}"
  commit_cmd = "git commit -m \"#{commit_msg}\""
  puts "Running command: #{commit_cmd}"
  system(commit_cmd)
  puts "Running command: git push"
  system("git push")
end
```

### Rubyコードの詳細解説

以下、コードの各ステップについて詳しく解説します。

1. **実行期間の設定と判定**

   - `boise_time` で、現在のUTC時刻から7時間引いた「America時間」を計算しています。
   - `start_date` と `end_date` に対象期間（2025/02/05～2025/03/11）の開始時刻と終了時刻を設定し、現在時刻がこの範囲内にあるかを判定します。
   - 対象期間外であれば、メッセージを出力してスクリプトを終了します。

2. **ディレクトリのパス設定**

   - 現在の作業ディレクトリから、Qiita用コンテンツのあるディレクトリ（`qiita-content`）と、もともと投稿候補のMarkdownファイルが存在する`refuge_qiita`ディレクトリのパスを組み立てています。

3. **Step 1: 対象ファイルの選択と移動**

   - `refuge_qiita` 内のファイル一覧から、名前が`stock*.md`にマッチするファイルを抽出します。
   - 複数ある場合は、番号が最も小さいファイル（先頭のもの）を選び、そのファイルを`qiita-content/public`ディレクトリへ移動します。
   - この処理により、投稿候補となるファイルが次のステップで利用できる状態となります。

4. **Step 5: `refuge_qiita`内のファイル削除のコミット＆push**

   - ファイルを移動した後、`refuge_qiita`ディレクトリに移動し、Gitの変更（移動による削除）をコミットし、リモートリポジトリへpushすることで、管理状態を更新します。

5. **Step 2: 新しい記事番号の決定**

   - `qiita-content/public`ディレクトリ内にある、`article*.md`形式のファイルを全て検索し、現在の最大番号を取得します。
   - 新しい記事番号は、既存の最大番号に1を加えたものとし、新たなファイル名（例：`article5.md`）を決定します。
   - 移動してきたファイルの名前を、新しい記事番号に合わせてリネームします。

6. **Step 3: 記事タイトルの抽出と保存**

   - リネーム後の記事ファイルを読み込み、各行の中から`title:`で始まる行を探します。
   - 見つかった場合、その行から`title:`を除去し、記事のタイトルとして抽出します。
   - 抽出したタイトルは、後で使用できるように`published_title.txt`として保存されます。
   - エラーが発生した場合は、例外処理でエラーメッセージを出力し、空のタイトルを設定します。

7. **Step 4: Qiita CLI を使用した記事投稿とGit操作**

   - 作業ディレクトリを`qiita-content`に変更し、Qiita CLIを使って記事を投稿するコマンド（`npx qiita publish articleX`）を実行します。
   - CLIの出力から、記事IDを抽出し、それを基に投稿後のQiita記事URLを生成します。
   - 生成したURLは`published_url.txt`に書き出されます（なお、複数行出力の場合は最初の行のみを使用）。
   - 最後に、Gitで変更をステージング（`git add -A`）、コミット、そしてリモートリポジトリへpushすることで、記事の追加が反映されます。

このように、コードは「ファイルの選択」「移動」「番号の決定」「タイトル抽出」「投稿処理」「Git操作」といった一連の手順でQiitaへの記事投稿とリポジトリの更新を自動化しています。

---

# まとめ

今回は、Qiitaへの記事投稿とGitHubへのpushを自動化するためのymlファイルおよびRubyスクリプトについて解説し、特にRubyコード内の各処理の詳細な流れについても説明しました。
実際に試してみたい方は、以下のGitHubリポジトリもご参照ください。

https://github.com/Taira0222/qiita-content





