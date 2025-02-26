---
title: 【Qiita】記事の投稿とGithubへのpushを行うスクリプト
tags:
  - Qiita
  - 初心者
  - 未経験エンジニア
  - 独学
  - QiitaCLI
private: false
updated_at: '2025-02-26T11:49:48+09:00'
id: ca0b292e4e08d015cce3
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカ在住で独学でエンジニアを目指している者です。
2024年10月6日からQiitaにて毎日投稿を続けていますが、Qiitaへの投稿やGitHubへのpush作業をスクリプトで自動化できないかと考え、今回作成しました。

## ディレクトリ関係図
今回の構成は以下のようになっています。
```
ユーザー/
├─ refuge_qiita/
│  ├─ stock1.md
│  ├─ stock2.md
│ 
├─ qiita_github/
│  ├─ public/
│  │  ├─ article1.md
│  │  ├─ article2.md
│  │  ├─ article3.md

```

* `refuge_qiita/`
記事のストックを保管するディレクトリです。
Qiita投稿時に、GitHubに不要なファイルまでpushされるのを防ぐため、この場所にストックを保存しています。
ファイル名は `stock数字.md` としています。

* `qiita_github/`
このディレクトリ内の `public` フォルダに記事ファイルを配置し、Qiita CLI を用いて `npx qiita publish article数字` コマンドで記事を投稿します。

## スクリプト
以下のスクリプトはChatGPTを利用して作成し、バグ発生時の対応を容易にするため、自分の得意なRubyで記述しています。
スクリプトの処理フローは以下の通りです。

1. `refuge_qiita`から最も数字が小さいstockファイルを選択し、`qiita_github/public`へ移動
2. 移動したファイルを、`qiita_github/public`内のarticleファイルの最大番号に基づいて、+1した名前にリネーム
3. `~/qiita_github`ディレクトリに移動後、各ターミナルコマンドを実行

```ruby
require 'fileutils'

# ホームディレクトリのパスを取得
home = Dir.home

# ディレクトリのパスを設定
qiita_github_dir = File.join(home, 'qiita_github')
public_dir       = File.join(qiita_github_dir, 'public')
refuge_dir       = File.join(home, 'refuge_qiita')

# --- Step 1: refuge_qiitaから数字が一番若いstockファイルを選択し、qiita_github/publicへ移動 ---
stock_files = Dir.entries(refuge_dir).select { |f| f =~ /^stock(\d+)\.md$/ }
if stock_files.empty?
  puts "refuge_qiita内に対象ファイルが見つかりません。"
  exit 1
end

# 数字部分でソートし、一番小さいファイルを選ぶ
smallest_file = stock_files.sort_by { |f| f.match(/^stock(\d+)\.md$/)[1].to_i }.first
puts "Moving file: #{smallest_file}"
source_path = File.join(refuge_dir, smallest_file)
dest_path   = File.join(public_dir, smallest_file)
FileUtils.mv(source_path, dest_path)

# --- Step 2: qiita_github/public内のarticleファイルから最大番号を取得し、+1した名前にリネーム ---
article_files = Dir.entries(public_dir).select { |f| f =~ /^article(\d+)\.md$/ }
if article_files.empty?
  puts "qiita_github/public内にarticleファイルが見つかりません。"
  exit 1
end

max_article_num = article_files.map { |f| f.match(/^article(\d+)\.md$/)[1].to_i }.max
new_article_num = max_article_num + 1
new_file_name   = "article#{new_article_num}.md"
new_file_path   = File.join(public_dir, new_file_name)
puts "Renaming moved file to: #{new_file_name}"
FileUtils.mv(dest_path, new_file_path)

# --- Step 3: ~/qiita_githubディレクトリに移動して各ターミナルコマンドを実行 ---
Dir.chdir(qiita_github_dir) do
  # system("git checkout article_push")
  # npx qiita publish コマンド（拡張子.mdは除く）
  publish_cmd = "npx qiita publish article#{new_article_num}"
  puts "Running command: #{publish_cmd}"
  system(publish_cmd)

  # git add -A コマンド
  puts "Running command: git add -A"
  system("git add -A")

  # git commit コマンド（メッセージにarticle番号を記載）
  commit_msg = "Add article#{new_article_num}"
  commit_cmd = "git commit -m \"#{commit_msg}\""

  puts "Running command: #{commit_cmd}"
  system(commit_cmd)

  # git push コマンド
  puts "Running command: git push"
  system("git push")
end
```

このスクリプトを用いることで、これまで記事投稿にかかっていた手間が大幅に削減されます。

# まとめ
今回作成したスクリプトにより、Qiitaへの投稿とGitHubへのpushの作業を自動化できるようになりました。
前回のcrontabの記事と今回のスクリプトを合わせて、スクリプトの実行すらも自動化できないか模索してみたいと思います。
