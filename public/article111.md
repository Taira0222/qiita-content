---
title: >-
  【Rails】uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger
  (NameError)の対処法
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-17T07:51:32+09:00'
id: 89fe772eb8d752da4db7
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！ アメリカで独学でソフトウェアエンジニアを目指している者です。
本日はRails Tutorial を進めている際に新たにアプリを作成しようとしたらエラーが発生したのでそれについて記事にしようと思います。
なお、一時的なものの可能性がありますので参考程度にしてください。

開発環境
ホストOS: Windows 11
ruby : 3.2.3
Rails : 7.0.4.3
Docker Desktop 


# エラーの原因と解決方法

2025年1月16日に、以下のコマンドを実行しました：

```bash
rails new _7.0.4.3_ sample_application
```
その後、rails -v を実行すると、以下のエラーが表示されました：

```ruby
uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger (NameError)
 ・
 ・
 ・
```
原因を調査したところ、`concurrent-ruby` gem が最近バージョン 1.3.5 にアップデートされたことが関係しているようでした。


## 解決方法
以下の手順で問題を解決しました：

1. Gemfile に次の行を追加します：
```ruby
gem 'concurrent-ruby', '1.3.4'
```

2. bundle install を実行します。
これでエラーが解消され、正常に動作するようになりました。
