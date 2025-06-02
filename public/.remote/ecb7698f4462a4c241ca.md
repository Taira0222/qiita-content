---
title: 【rails】mailerのテストで発生したエラーと対処法
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - Mailer
  - 独学
private: false
updated_at: '2025-06-02T12:18:59+09:00'
id: ecb7698f4462a4c241ca
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails チュートリアルのアウトプットとしてアプリを製作しています。
Devise の実装が完了し、Mailer のテストコードを書いていたのですが、エラーが出てきて困っていました。
その時に私がとった対策を記事にしておこうと思いました。

## 問題のコード

```ruby
class DeviseMailerTest < ActionMailer::TestCase
  test 'confirmation_instructions' do
    @user = users(:user1)
    raw_token, enc_token = Devise.token_generator.generate(User, :confirmation_token)
    @user.update(confirmation_token: enc_token)

    mail = Devise::Mailer.confirmation_instructions(@user, raw_token) # メールを送信

    assert_equal [@user.email], mail.to
    assert_equal '（重要）アカウントの有効化について', mail.subject
    assert_equal [Devise.mailer_sender], mail.from # from は config/initializers/devise.rb 内の config.mailer_sender を参照
    assert_match @user.name, mail.body.encoded
    escaped = CGI.escapeHTML(raw_token) # raw_token を HTML エンコード
    assert_match escaped, mail.body.encoded
  end
end
```

## どこでエラーになるか？

このテストで `include Rails.application.routes.url_helpers` を書かない場合、

```ruby
mail = Devise::Mailer.confirmation_instructions(@user, raw_token)
```

この行でエラーが発生します。

### エラー内容の例

- `undefined method 'confirmation_url' for #<Devise::Mailer:...>`
- `NoMethodError: undefined method 'confirmation_url'`

これは Devise の Mailer が確認メール本文を生成する際、内部で `confirmation_url` などの**ルートヘルパー**を呼び出しているためです。

---

## ルートヘルパー(url_helpers)とは？

Rails では `routes.rb` で定義されたルートごとに `user_confirmation_url` などのヘルパーメソッドが自動生成されます。

これらのヘルパーをコントローラやビューで使う場合は何も意識する必要はありませんが、
**Mailer クラスやテストクラスで使いたい場合**は `Rails.application.routes.url_helpers`を include する必要があります。

### 例

```ruby
include Rails.application.routes.url_helpers
```

これをテストクラスや Mailer クラスに書くことで、

- `user_confirmation_url`などのメソッドが使えるようになります。

---

## まとめ

- Devise::Mailer がメール本文を生成する際、ルートヘルパー（confirmation_url など）を内部で呼び出す
- そのため、テストやカスタム Mailer では `include Rails.application.routes.url_helpers`を忘れると NoMethodError になる
- テストや Mailer を実装するときは必ず include することを意識しよう

---

## 参考リンク

https://techracho.bpsinc.jp/hachi8833/2021_03_05/104476
