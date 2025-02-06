#!/usr/bin/env ruby
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
