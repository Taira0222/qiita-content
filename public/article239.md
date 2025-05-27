---
title: 【rails】use.ymlでencrypted_passwordをハッシュ化する方法
tags:
  - Rails
  - devise
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-27T12:09:14+09:00'
id: bf11c946e3737576faac
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在 Rails アプリを devise を用いて作成しています。
`test/fixtures/user.yml` に user を設定してテストに使用することがよくあります。

```yml
user1:
  name: takeshi
  email: test1@example.com
  encrypted_password: '何を書けばいい？'
  confirmed_at: <%= Time.current %>
```

このとき、`encrypted_password`にパスワードを設定したいのですが、devise は内部でどのようにハッシュ化しているのかわかりにくい、という問題にぶつかりました。
そこで今回は、`encrypted_password`の値をどう設定すればよいか、devise のハッシュ化処理のソースコードを読み解くことで解説します。

## `encrypted_password`のハッシュ化方法

[https://github.com/heartcombo/devise](https://github.com/heartcombo/devise)

上記リポジトリの `devise/lib/devise/encryptor.rb` の 7 行目に該当の処理があります。

```ruby
module Devise
  module Encryptor
    def self.digest(klass, password)
      if klass.pepper.present?
        password = "#{password}#{klass.pepper}"
      end
      ::BCrypt::Password.create(password, cost: klass.stretches).to_s
    end
    # ...(省略)
  end
end
```

`digest`クラスメソッドは、第一引数にクラス（ここでは User）、第二引数にパスワードを渡して呼び出すことで、devise が期待する形式でハッシュ化できます。

つまり、fixture の `user.yml` で `encrypted_password` を指定するには、以下のように書くことができます。

```yml:user.yml
user1:
  name: takeshi
  email: test1@example.com
  encrypted_password: <%= Devise::Encryptor.digest(User, 'password') %>
  confirmed_at: <%= Time.current %>
```

## まとめ

ハッシュ化の方法をソースコードから探すアプローチは、Rails チュートリアルでも学習した大切な方法です。
今後も困ったときには積極的にソースコードを読む姿勢を大事にしたいと思います。

## 参考資料

https://github.com/heartcombo/devise
