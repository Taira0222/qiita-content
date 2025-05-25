---
title: 【rails】deviseの導入方法
tags:
  - Rails
  - devise
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-25T12:18:13+09:00'
id: 217668f58a7e72d33ba3
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在 Rails アプリを devise を用いて作成しています。
本日は devise の実装方法を注意点も含めて解説していきたいと思います。

## 1. Devise とは？

Devise は、ユーザー認証に必要なほぼすべての機能（ログイン、ログアウト、パスワードリセット、メール認証など）を簡単に導入できる Rails 用の Gem です。多くの Rails アプリで利用されており、導入手順も公式にドキュメント化されています。

---

## 2. 導入手順

### Gem の追加

まず、Gemfile に devise を追加します。

バージョンの指定があれば、適宜追加してください

```ruby
# Gemfile
gem 'devise','4.9.4'
```

追加したら、以下のコマンドで Gem をインストールします。

```bash
bundle install
```

### Devise のインストール

Devise 本体をセットアップします。

```bash
bin/rails generate devise:install
```

実行すると、初期設定のための手順や注意点がターミナルに表示されます。
（例：default_url_options の設定、flash メッセージの表示場所など）

### User モデルの作成

認証用の User モデルを作成します。モデル名は user 以外でも OK ですが、基本は user で進めます。

```bash
bin/rails generate devise User
```

これで User モデルとマイグレーションファイルが自動生成されます。

この時に、db/migrate に TIMESTAMP_devise_create_user.rb が生成されるので、自分で username や name を追加したい場合は加える必要があります。

```ruby
# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :name, null:false #別途追加
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end

```

私は会員登録させる際に登録したメールの認証を持たせたかったので、`Confirmable` を追加しました。

(これはもともとコメントアウトされているので解除すれば OK)

`Confirmable `を追加した場合、`app/model/user.rb` に忘れずに追加しましょう。

`confirmable` 以外はおそらく自動で入っているはずです。

```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable #confirmableは自分で追加
```

このあたりの役割がわからない場合は以下の記事を参考にするといいと思います

https://qiita.com/cigalecigales/items/f4274088f20832252374#2-devise%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E6%A6%82%E8%A6%81

### マイグレーションの実行

データベースに users テーブルを作成します。

```bash
bin/rails db:migrate
```

### ルーティングの追加

routes.rb に`devise_for :users`が自動で追記されているか確認します。

```ruby
# config/routes.rb
devise_for :users
```

必要に応じて、コントローラーやパスをカスタマイズする場合は

```ruby
devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
```

のように書きます。

### ビューの生成（カスタマイズしたい場合）

デフォルトの Devise の view を編集したい場合は、以下でビューを生成します。

```bash
bin/rails generate devise:views
```

`app/views/devise`配下に各種 view ファイルが生成されるので、自由に編集できます。

ここで注意事項ですが、GitHub の devise の README には

```
bin/rails generate devise:views users
```

と書いてありますが、これを実行すると`app/views/users`  にファイルが作成されます。

意図的ならいいですが、後々 mailer をいじる際に devise のデフォルトで`app/views/devise`配下の mailer の view を読み込むようなので上記の`bin/rails generate devise:views`  をおすすめします。

## 3. 動作確認

- サーバーを起動して（`bin/dev`や`bin/rails s`）、`/users/sign_up`や`/users/sign_in`にアクセスし、ユーザー登録やログインができるか確認しましょう。

---

## まとめ・ポイント

- Devise は Rails 標準の認証 Gem として定番。認証機能を一から作る必要なし。
- 公式ドキュメントが充実しているので、不明点があれば devise の README を参照するのがオススメ。
- ビューやルーティング、コントローラーは柔軟にカスタマイズできる。

## 参考資料

https://github.com/heartcombo/devise
