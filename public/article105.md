---
title: 【Rails】Ruby on Rails Tutorial 6章を読み終えて
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-11T10:46:36+09:00'
id: 09b5b16c99646300d744
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカで独学でエンジニアを目指している者です。
現在、Ruby on Rails Tutorialを使ってRailsを勉強しており、学んだことを忘れないように振り返りの記事を書いてみました。

# ユーザーのモデルを作成する
今まではcontrollerやviewに目を向けてきましたが、本章から少しずつmodelを使い始め少し抽象度が増したような気がします。
そうはいってもRailsのビジネスロジック的な要素はmodelで引き受けることから難しくなっていしまうのは至極当然なのかもしれません。

## Userモデル
以前の章でUser コントローラーは作成しましたが、Userはログインの情報を管理するものだと思うのでmodelをメインに触っていくことになります。
modelを作成し、dbにその属性を入れるコマンドは覚えておこうと思いました
* `$ rails generate model User name:string email: string`
* `$ rails db:migrate`
なお、modelの場合は基本は単数形で命名するようです。
`$ rails generate model User name:string email: string`で生成された`db/migrate/[timestamp]_create_users.rb`はDBの要素について書いてあります
```ruby:[timestamp]_create_users.rb
 class CreateUsers < ActiveRecord::Migration[7.0]
    def change
        create_table :users do |t|
        t.string :name
        t.string :email

        t.timestamps
        end
    end
 end
 ```
timestampsは作成日時(created_at)と更新日時(update_at)を記録します
上記の内容で問題なければ`$ rails db:migrate`でDB内にmigrateするという流れになります。
なお、migrateされたデータはdb/test.sqlite3の中に入っていて`DB Browser for SQLite`というツールを使用して確認することができました。


## ユーザーを検証する
上記ではUserモデル上で`name`,`email`という属性を作成しましたが、それぞれ何でも入力できていいわけではないよということです。
例えば、`name`を空白で登録できてしまったらまずいですし、`email`であれば`fjajfakjf@fkdkfafjf;:.`みたいなのが登録された際にはじかないとまずいということです

### 空白登録の排除
これらのような例外をはじくのをバリデーションといいvalidatesで設定することができるようです
```ruby:uesr.rb
 class User < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true
 end
 ```
 上記ではpresence(存在)がtrue つまり存在している必要があるのでこれで空白だとはじかれるようになりました。
 それが正常に動作するかtest/models/user_test.rbを以下のように編集しました
 ```ruby:user_test.rb
class UserTest < ActiveSupport::TestCase
  def setup
    @user =User.new(name:"ExampleUser",email:"user@example.com")
  end

  test "name should be present"do
    @user.name =" "
    assert_not @user.valid?
  end
  test "email should be present"do
    @user.email =" "
    assert_not @user.valid?
  end
end
```
本来は書いてあるコードもありましたが、端折って関係あるコードのみ残しました
`name should be present`テストでは、`name`を空白にしてその場合`false`になるかの確認、つまり`user.rb`のバリデーションが有効か否かを確認しています。下のテストの同様です

### 登録文字長さの規制
これらは比較的簡単で、user.rb,user_test.rbそれぞれ以下のように書きました
```ruby:user.rb
class User < ApplicationRecord
  before_save {self.email = email.downcase}
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255}
end
```
先ほどのコードに`length: {maximum: 数字}`とすると数字分までしか入力できなくなるようです。これの反対にminmumもあるようです。
```ruby:user_test.rb
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"Example User", email: "user@example.com",
                    password: "foobazbar", password_confirmation: "foobazbar")
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.name = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
end
```
`name should not be too long`テストでは50文字以上入れたら`false`になるか、`email should not be too long`では244文字と`@example.com`(12文字)の256文字だと`false`になるかのテストを行いバリデーションの確認を行いました

### フォーマットの制限
これからは`email`に対しての作業がメインとなります。`name`よりも`email`のほうが制限は難しくこういった場合に正規表現を用いるとすんなりといきます。私は少し知識が抜けていたので「たのしいRuby」を見返して思い出しながら進めました
user.rbとuser_test.rbを以下のように書いていきました

```ruby:user.rb
class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, 
                                    format: {with:VALID_EMAIL_REGEX}, 
end
```
正規表現って知らない人から見ると呪文すぎるなと思います。
これは演習問題のコードを反映させているので教材に書いてあるモノではないですが、`aaaa@foo..jp`のようなピリオドが2回続くモノもはじけるようになっています。
一応上記の正規表現は
* /　　/: 正規表現であることを示します。
* /   /i: 大文字と小文字を区別しないです。つまり`\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z`は正規表現で大文字と小文字を区別しないという意味です
ここからさらに中の説明をしていきます
* \A[\w+\-.]+: 文頭で英数字、+、-、.のどれかに1つ以上マッチします。`test@example.com`というメールアドレスがあれば`test`に該当します
  * \A は文字列の文頭から始まります。
  * [  ]+: これの中のどれか1回以上その前の文字列を繰り返します。*は0回以上を表します。
  * \w:英数字にマッチします
  * +: これは正規表現的な意味はなく＋にマッチします
  * \-: これも正規表現的な意味はなく-にマッチします。\(バックスラッシュ)をすることで意味のあるモノを文字列として扱えます
  * .: これは正規表現的な意味はなく.にマッチします
* @[a-z\d\-]+: @と小文字のアルファベット、数字、ハイフンの内どれかを1回以上使用します。test@example.comというメールアドレスがあれば`@example`に該当します
  * @: 正規表現的な意味はなく@にマッチします
  * a-z: 小文字のアルファベットどれかにマッチします
  * \d: 0～9までの数字とマッチします
* (\.[a-z\d\-]+)*: .(ピリオド)と小文字のアルファベット、ハイフンのどれかを1回以上使用したものを0回以上繰り返します。(.英数字等)を0回以上使用するという意味です。`test@example.com`というメールアドレスがあれば該当なしですが、`test@example.co.jp`であれば`.co`に該当します。

```ruby:user_test.rb
test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
```
該当部分のみを抜き出しました。なお、inspectメソッドを使っていることがわかります。
例えば`user@example,com`でfalseになり、inspectメソッドを使用しない場合
```ruby
user@example,com should be invalid
```
となり、ダブルクオートがないため、どこまでかみずらかったり、特殊文字や空白の有無が分かりにくくなります。
一方でinspectを使用すると
```ruby
"user@example,com" should be invalid
```
となるのでとても見やすくなります。

### 一意性を検証する 
ここではemailを重複なくするように設定しました。ここで重要なのは`user@example.com`と`USER@example.com`の区別をつけないような設定にしようと思います。
```ruby:user.rb
class User < ApplicationRecord
  before_save {self.email = email.downcase} # 追加
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, 
                                    format: {with:VALID_EMAIL_REGEX}, 
                                    uniqueness: true # 追加
end
```
まず、`before_save {self.email = email.downcase}`について、、Active Record のコールバック（callback）メソッドです。以下のテストコードだと@user.saveの直前で機能します。
```ruby:user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"Example User", email: "user@example.com")
  end

   ## ~~~~省略~~~~~~~~
  test "email addresses should be unique" do # 追加
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lowercase" do　# 追加
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
 
end
```
追加した1つめのテストについて、まったく同じ属性の`duplicate_user`を作成し、falseが出るかをテストしています
2つめのテストは、大文字が混ざっていても小文字にしたアドレス(`mixed_case_email.downcase`)と`@user.reload.email`が同じか否かを確認しています。`before_save {self.email = email.downcase}`によって小文字となっているため`true`になることを想定しています。

## セキュアなパスワードを追加する
パスワードを追加する上で設定するべき項目として以下があげられます。
* ハッシュ化してデータベースに保存
これはwebの勉強しているときにでてきましたが、パスワードの保存はセキュリティ面を加味してハッシュで行っています
上記のようにするためには、`gemfile`に`bcrypt`というハッシュ化するライブラリを挿入する必要があります
それが完了したら、`$ rails generate migration add_password_digest_to_users password_digest:string`でpassword_digest カラムを追加するマイグレーションを作成します。
内容を確認して `$ raills db:migrate`でデータベースに属性を追加します。


* パスワードの最小文字数を設定
会員サイトに登録された方ならわかると思いますが、最低の文字数を設定するためにuser.rbとtest_user.rbに変更を加える必要があります
```ruby:user.rb
class User < ApplicationRecord
  before_save {self.email = email.downcase}
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, 
                                    format: {with:VALID_EMAIL_REGEX}, 
                                    uniqueness: true
  has_secure_password # 追加
  validates :password, presence: true, length: { minimum: 8} # 追加
end
```
`has_secure_password`はパスワードを追加するためのコマンドで、`password_digest`以外にデータベース上には登録されていませんが`password`と`password_confirmation`が仮想的に追加されます。
`validates :password, presence: true, length: { minimum: 8}`で最低文字制限8文字と空白での登録はできないようにしています。

```ruby:test_user.rb

require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"Example User", email: "user@example.com",
                    password: "foobazbar", password_confirmation: "foobazbar")# 追加
  end

  ## ~~~~省略~~~~~~~~

  test "password should be present (nonblank)" do # 追加
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid? 
  end

  test "password should have a minimum length" do # 追加
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end
 
end
```

`@user = User.new(name:"Example User", email: "user@example.com", password: "foobazbar", password_confirmation: "foobazbar")`には`password`と`password_confirmation`が追加されています。これはあくまでもUserオブジェクト上のみ存在しているように見えますがデータベースには存在しないカラムとなります。

追加された1つめのテストは、passwordを空白の文字を8つにしてもfalseを返すかの確認、2つ目のテストはpasswordを`a`7つにしてもfalseになるかの確認をしています。

# まとめ
今回はuser周りについて学びましたが、身の回りで使用されている機能がこうしてコードやフレームワークで実装できるのはとても面白いなと思いました。また7章を読んだら記事にしようと思います。
