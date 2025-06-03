---
title: 【rails】devise 日本語対応
tags:
  - Rails
  - devise
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-06-03T12:14:21+09:00'
id: ed2ccaee0e5db3e85d1f
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails チュートリアルのアウトプットとしてアプリを製作しています。
devise の実装も順調に進んだのですが、アプリの言語をどうにかして日本語にできないかと悩んでいましたが、意外と簡単にできることが発覚しました。
今回はその方法について記事にしようと思います。

開発環境

- rails 8.0.3
- docker/devcontainer

### 1. devise-i18n をインストール

Devise の日本語化には `devise-i18n` という gem を使うのが一般的です。

もし devise 以外も日本語対応させたい場合は一緒に`rails-i18n`  という gem を追加しましょう

#### Gemfile に追加

```ruby
gem 'devise-i18n'
gem "rails-i18n" # rails の機能を日本語にしたい場合
```

#### bundle install

```bash
bundle install
```

---

### 2. 日本語の言語ファイルを確認

`devise-i18n` を入れると、日本語の翻訳ファイルが自動的に使われるようになります。

私は以下より日本語対応の devise 用の devise.ja.yml をコピーしました。

[https://gist.github.com/satour/6c15f27211fdc0de58b4](https://gist.github.com/satour/6c15f27211fdc0de58b4)

---

### 3. Rails のデフォルトロケールを日本語に設定

#### config/application.rb

```ruby
module YourAppName
  class Application < Rails::Application
    config.i18n.default_locale = :ja
  end
end
```

---

### まとめ

- `devise-i18n` を入れるだけで多くの部分が日本語化される
- 必要に応じて翻訳ファイルを編集し、柔軟にカスタマイズ可能
- メールテンプレートも日本語化すれば、より丁寧な印象に
