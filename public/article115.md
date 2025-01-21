---
title: 【Rails】RubyのVersion変更(Rails Tutorial用)
tags:
  - Ruby
  - Rails
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
private: false
updated_at: '2025-01-21T15:16:28+09:00'
id: 8f15247bfffbe9067f20
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でエンジニアを目指しているTairaです。
現在、`Rails Tutorial`という教材を進めていますが、開発環境として `GitHub Codespaces` ではなく、`Docker + VSCode` を使用しています。

教材で指定されているRubyのバージョンと`.devcontainer`で設定されているRubyのバージョンが異なるため、今回はRubyのバージョンを変更する方法をまとめました。

なお、Dockerの知識が十分にある方は `Dockerfile` や `docker-compose.yml` を編集することで変更可能ですが、私はまだその知識が浅いため、別の方法でバージョンを変更しました。

# Rubyバージョンの変更手順
教材で使用されているRubyのバージョンは 3.2.3 ですが、`.devcontainer` の設定では `3.1.4` になっています(2025年1月20日現在)。この違いを解消するために以下の手順を行いました。

1. Ruby 3.2.3のインストール
まず、指定のバージョン（Ruby 3.2.3）をインストールします。

```bash
rvm install 3.2.3
```

インストール可能なバージョンを確認したい場合は以下のコマンドを使用してください
```bash
rvm list known
```
2. Rubyのバージョンを切り替え
Ruby 3.2.3をプロジェクト全体で使用するように切り替えます。

```bash
rvm use 3.2.3 --default
```
3. .ruby-versionの内容変更
ここまでの手順だけでは、ディレクトリを移動した際にRubyのバージョンが元に戻る場合があります。
その原因は、ディレクトリ内にある `.ruby-version` ファイルに `system` と記載されているためです。

以下の手順でファイルの内容を変更します。

* `ruby-version` ファイルの確認
現在のディレクトリに .ruby-version ファイルがあるか確認します。
```bash
ls -a
```
ファイルが存在する場合、その内容を確認します。

```bash
cat .ruby-version
# 出力例: system
```
この場合、system はシステムデフォルト（今回の例ではRuby 3.1.4）を使用する設定になっています。
* `.ruby-version` の修正
使用したいバージョン（Ruby 3.2.3）を明示的に指定します。
```bash
echo "3.2.3" > .ruby-version
```
これで、該当ディレクトリ内ではRuby 3.2.3が自動的に使用されるようになります。

# まとめ
以上の手順で、Docker環境でのRubyバージョンを簡単に変更することができました。.ruby-version ファイルを活用することで、特定のプロジェクトで使用するRubyのバージョンを柔軟に管理できます。
Dockerの知識がついてきたら、`.devcontainer`を変更する方法も模索してみようと思います
