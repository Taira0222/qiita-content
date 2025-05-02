#!/usr/bin/env ruby
require 'time'
require 'fileutils'


# 時間指定を撤廃した

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

  # GitとGitHubに変更を反映させている
  puts "Running command: git add -A"
  system("git add -A")
  commit_msg = "Add article#{new_article_num}"
  commit_cmd = "git commit -m \"#{commit_msg}\""
  puts "Running command: #{commit_cmd}"
  system(commit_cmd)
  puts "Running command: git push"
  system("git push")
end
