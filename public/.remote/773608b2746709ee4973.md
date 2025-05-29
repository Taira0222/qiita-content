---
title: 【rails】devise mailer.previewの作成方法
tags:
  - Rails
  - devise
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-29T12:12:08+09:00'
id: 773608b2746709ee4973
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails アプリを devise を用いて作成しています。

会員登録画面の実装が完了したのですが、そのメールの内容を確認したいと思い、Rails チュートリアルで `test/mailers/previews/user_mailer_preview.rb` を実装したことを思い出しました。
そこで devise でもその機能を実装しようと考え、Rails チュートリアルを参照しつつ devise のソースコードの中から必要な情報を抽出して `devise_mailer_preview.rb` を作成しました。

## Rails チュートリアルで実装したコード

```ruby
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end
end
```

上記が実際に Rails チュートリアルで実装したコードです。
ここでポイントとなるのは、

- `ActionMailer::Preview` を継承すること
- メールで使用するトークンを設定すること
- from や to、subject を設定するメソッドの実装をすること

## devise での mailer_preview の実装

### 1. `confirmation_token` の生成

devise のソースコード `devise/lib/devise.rb` を参照すると、以下のような記述があります。

```ruby
module Devise
  autoload :TokenGenerator, 'devise/token_generator'
  # ...省略
  mattr_accessor :token_generator
  @@token_generator = nil
end
```

ここで token 生成の処理が書かれており、`devise` モジュール内で `token_generator` というクラス変数が設定されていることがわかります。

さらに、`devise/lib/devise/token_generator.rb` には以下のような内容があります（一部省略）。

```ruby
def generate(klass, column)
  key = key_for(column)
  loop do
    raw = Devise.friendly_token
    enc = OpenSSL::HMAC.hexdigest(@digest, key, raw)
    break [raw, enc] unless klass.to_adapter.find_first({ column => enc })
  end
end
```

これを参考に、`confirmation_token` を以下のように設定できます。

```ruby
raw, enc = Devise.token_generator.generate(User, :confirmation_token)
user.confirmation_token ||= enc
```

ここで使用するのは、エンコードされた `enc` を `confirmation_token` として設定します。

### 2. devise の mailer メソッドの利用

`devise/app/mailers/devise/mailer.rb` を参照すると、

```ruby
if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers

    def confirmation_instructions(record, token, opts = {})
      @token = token
      devise_mail(record, :confirmation_instructions, opts)
    end
```

この `confirmation_instructions` メソッドを利用して、最終的に mailer_preview を以下のように実装できます。

```ruby
# Preview all emails at http://localhost:3000/rails/mailers/devise_mailer
class DeviseMailerPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/devise_mailer/confirmation_instructions
  def confirmation_instructions
    user = User.first
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user.confirmation_token ||= enc
    Devise::Mailer.confirmation_instructions(user, user.confirmation_token)
  end
end
```

## 【追記】devise のメソッドを使用して preview を表示させる

```ruby
#Preview all emails at http://localhost:3000/rails/mailers/devise_mailer

class DeviseMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/devise_mailer/confirmation_instructions
  def
    user = User.last
    user.send_confirmation_instructions # enc_tokenをuserのconfirmation_tokenに設定
    raw_token = user.instance_variable_get(:@raw_confirmation_token) # userオブジェクトの@raw_confirmation_tokenを取得
    Devise::Mailer.confirmation_instructions(user, raw_token)
  end

  # http://localhost:3000/rails/mailers/devise_mailer/email_changed
  def email_changed
    user = User.last
    Devise::Mailer.email_changed(user)
  end

  # http://localhost:3000/rails/mailers/devise_mailer/reset_password_instructions
  def reset_password_instructions
    user = User.last
    raw_token = user.send_reset_password_instructions # 返り値がraw_tokenとなるのでinstance_variable_getは不要
    Devise::Mailer.reset_password_instructions(user, raw_token)
  end
end
```

`confirmation_instructions` や `reset_password_instructions`の上記のメソッドはソースコードに書いてあるので見てみてください

https://github.com/heartcombo/devise/blob/fec67f98f26fcd9a79072e4581b1bd40d0c7fa1d/lib/devise/models/confirmable.rb#L257

## 参考資料

https://github.com/heartcombo/devise
