---
title: >-
  【rails】Rails + DevContainer + Tailwind
  CSS環境でbin/devがGem::FilePermissionErrorになる原因と対処法
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - tailwind
private: false
updated_at: '2025-05-22T12:10:09+09:00'
id: ffa37b8fb7d13edf8988
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

Rails 8 + DevContainer 環境で `tailwindcss-rails` を使って開発を始めようとしたところ、`bin/dev` 実行時に以下のようなエラーに遭遇しました：

```
Installing foreman...
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /usr/local/... directory.
```

この記事では、このエラーの原因と解決策を明確に解説します。

---

## 前提環境

- Rails 8.0.2
- Node 24
- tailwindcss-rails 3.3.1（Tailwind CSS v3 対応）
- DevContainer（Docker ベース）
- foreman を使用して bin/dev で Rails サーバーと Tailwind ビルドを同時起動

---

## 通常の tailwind を rails で反映させる方法

### 1. Gemfile に tailwind-rails 3.3.1 を入力

```
gem "tailwindcss-rails", "3.3.1"
```

### 2. rails tailwindcss\:install を実行

```
rails tailwindcss:install
```

### 3. bin/dev を実行

→ ここで失敗。

## エラーの原因

### 1. `bin/dev` による foreman のグローバルインストール処理

デフォルトの `bin/dev` には以下のような処理が含まれています：

```sh
if ! gem list foreman -i --silent; then
  echo "Installing foreman..."
  gem install foreman
fi
```

これは「foreman がグローバル gem 環境にインストールされていない場合、自動でインストールする」という処理です。

しかし、**DevContainer などの環境では **********************\*\*\*\*************************\*\*************************\*\*\*\*************************`/usr/local/...`************************\*\*************************\*\*\*\*************************\*\************************* への書き込み権限がないため、 ************************\*\*************************\*\*\*\*************************\*\*************************`gem install`************************\*\*************************\*\*\*\*************************\*\************************* が失敗\*\*します。

その結果、以下のようなエラーが発生します：

```
Gem::FilePermissionError: You don't have write permissions...
```

また、foreman を Gemfile で管理していても `gem list` はグローバル gem しか見ないため、毎回「未インストール」と誤判定されてしまいます。

---

## 正しい解決方法

### ✅ Gemfile で foreman を管理

```ruby
gem "tailwindcss-rails", "3.3.1"

group :development do
  gem 'foreman'
end
```

### ✅ bundle install

```bash
bundle install
```

### ✅ `bin/dev`を修正

以下のように、`gem install foreman` の自動処理を削除し、 `bundle exec` を明示します：

```sh
#!/usr/bin/env sh

export PORT="${PORT:-3000}"
export RUBY_DEBUG_OPEN="true"
export RUBY_DEBUG_LAZY="true"

# foremanはGemfileで管理しているためbundle execで呼び出す
exec bundle exec foreman start -f Procfile.dev "$@"
```

### ✅ tailwindcss のセットアップ

```bash
rails tailwindcss:install
```

これにより `application.tailwind.css` や `tailwind.config.js` などが生成されます。

---

## まとめ

| 課題                             | 解決策                                                  |
| -------------------------------- | ------------------------------------------------------- |
| `gem install foreman` が失敗する | Gemfile に書いて `bundle install` で管理する            |
| `bin/dev` が毎回失敗する         | `gem install` 処理を削除し `bundle exec foreman` に変更 |
| foreman が見つからない           | `bundle exec` を使うことで Bundler 環境を明示           |

この方法で、DevContainer や CI 環境でも安定して Rails + Tailwind CSS の開発が行えるようになります。

---
