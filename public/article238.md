---
title: 【rails】devise で独自のカラムを追加する方法
tags:
  - Rails
  - devise
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-06-03T04:42:37+09:00'
id: 4f3c0d9dab7f01432e73
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在 Rails アプリを devise を用いて作成しています。
前回は devise の導入方法についての記事を書きましたが、devise を使うことであらかじめ `email` や `encrypted_password` などのカラムが与えられます。
しかし、name や username 等の独自カラムを追加したい場面も多いでしょう。
そこで本日は devise で独自カラムを追加する方法について解説します。

## 前提

まず、以下のコマンドで devise の user モデルを作成します。

```bash
bin/rails generate devise User
```

このコマンドで User モデルとマイグレーションファイルが自動生成されます。

生成された db/migrate/TIMESTAMP_devise_create_users.rb を開き、name や username など追加したいカラムを追記します。

```ruby
class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :name, null: false # 追加
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      # ...（省略）
      t.timestamps null: false
    end
    # ...（省略）
  end
end
```

上記に name を追加したら、以下でマイグレーションを適用します。

```bash
bin/rails db:migrate
```

正常に追加できていれば、`db/schema.rb` の users テーブルに name が含まれていることを確認してください。

```ruby
create_table "users", force: :cascade do |t|
  t.string "name", null: false # 追加されていることを確認
  # ...（省略）
end
```

## このままだと何が問題なのか？

devise のコントローラーは初期状態では `email` や `password` しか許可していません。
そのため、signup 画面で name を送信しても保存されません。
独自カラム（例: name）をフォームから保存できるようにするには strong parameters の追加設定が必要です。

ここでは signup（registrations コントローラ）への追加方法を紹介します。

### Devise コントローラーのカスタマイズ

まず devise のコントローラーを生成します。

```bash
rails generate devise:controllers users
```

次に `app/controllers/application_controller.rb` に `configure_permitted_parameters` メソッドを追加します。

```ruby
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
```
`configure_permitted_parameters`はストロングパラメータを指しており、deviseで自分で作成したカラムを追加してサインインの時に使用したいときは`application_controller.rb`にまとめて書いておくことが一般的なようです。


### 動作確認

これでサインアップ時やプロフィール編集時に name カラムが保存されるようになります。
画面や rails console で name が登録できているか確認しましょう。

## 参考資料

https://github.com/heartcombo/devise
