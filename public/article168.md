---
title: 【Rails】インスタンス変数をセッターとして使用する際にはselfが必要
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-16T12:51:08+09:00'
id: 0a9693f6f4f8e2233779
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学でエンジニアを目指している taira です。

日本からアメリカに帰ってきて少しずつですが、勉強を開始しRailsチュートリアルを使用して勉強しています。
今回はRailsチュートリアルを学習する中で、インスタンス変数の扱いにおける`self`の必要性について新しく学んだことをまとめます。

## コード例（Railsチュートリアルより引用）

```ruby
class User < ApplicationRecord
  attr_accessor :remember_token

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
end
```

## インスタンス変数とローカル変数の違い

Railsチュートリアル内で、永続的なセッションを実装するために`remember`メソッドが定義されています。最初は以下のように書けるのではないかと考えました。

```ruby
remember_token = User.new_token
```

しかし、この書き方だと`remember_token`はインスタンス変数ではなくローカル変数として認識されてしまいます。インスタンス変数として正しく動作させるためには、明示的に`self`を使って以下のように書く必要があります。

```ruby
self.remember_token = User.new_token
```

こうすることでセッターメソッドとして動作し、インスタンス変数`@remember_token`に値が代入されます。

## セッターで`self`が必要な理由

Rails（およびRuby）の仕様として、代入操作（`=`）を使った場合、`self`を付けないとローカル変数として扱われます。したがって、インスタンス変数やアクセサメソッド経由で代入する際には、明示的に`self.`をつける必要があります。

## `self`が省略可能な場合

一方で、インスタンスメソッドの呼び出し時には`self`を省略できます。例えば、以下のように書くことができます。

```ruby
before_save { email.downcase! }
```

ここで`email`はメソッド呼び出し（`email()`）であるため、ローカル変数とはならず、`self`を明示しなくても問題なく動作します。

逆に、代入操作では以下のように明示する必要があります。

```ruby
before_save { self.email = email.downcase }
```

## まとめ

- インスタンス変数（またはアクセサメソッド経由）の代入時は`self`を必ずつける
- メソッド呼び出しでは`self`を省略可能
- Rubyの挙動を理解し、必要な場面で`self`を明示することが重要



