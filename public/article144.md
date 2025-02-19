---
title: 【Rails】form_with
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-02-19T11:46:05+09:00'
id: d39ee7aebb97b25873a9
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカにて独学でエンジニアを目指している者です。
現在、Railsチュートリアルを用いて学習を進めていますが、viewで扱うform_withがどのように動いているのかわからなかったので自分なりにまとめてみました

## `form_with` の基本
`form_with` は、Rails の `ActionView::Helpers::FormHelper` に定義されている組み込みのヘルパーメソッドです。
例えば、新規ユーザー登録フォームを作成する場合、コントローラーの new アクションでは次のようにインスタンス変数をセットします。

```ruby
# app/controllers/users_controller.rb
def new
  @user = User.new
end
```
そして、対応するビュー（new.html.erb）では form_with を使ってフォームを作成します。
```html
<%= form_with(model: @user) do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :email %>
  <%= f.email_field :email %>

  <%= f.label :password %>
  <%= f.password_field :password %>

  <%= f.label :password_confirmation, "Confirmation" %>
  <%= f.password_field :password_confirmation %>

  <%= f.submit "Create my account", class: "btn btn-primary" %>
<% end %>
```
このコードにより、Rails は @user の状態に基づいて適切なフォームを自動生成します。

### model: オプションの役割
`form_with(model: @user)` と記述することで、Rails は以下のような自動処理を行います
* **フォーム送信先の URL と HTTP メソッドの自動決定**

  * もし `@user` が新規（`User.new` で生成された未保存オブジェクト）の場合、Rails はフォームを アクションを`/users`(RESTfulな実装の場合、`/users` は`create` か`index`のどちらか),メソッドを`POST` に送信するよう設定します。
  * 一方、`@user` がすでにデータベースに保存されている場合（例えば、`User.find(params[:id])` で取得した既存オブジェクト）、Rails は `PATCH /users/:id` に送信するように自動で切り替えます。
  これは、内部で **`@user.persisted?` の状態を確認する**ことで実現されています。
* **入力フィールドの name 属性の自動設定**

  * フォーム内で、たとえば `f.text_field :name` とすると、Rails は` <input type="text" name="user[name]" id="user_name">` として HTML を生成します。
  * これにより、フォーム送信時のパラメータは `params[:user][:name]` の形で受け取ることができ、ストロングパラメータと組み合わせて安全に処理できます。
* **フォームの値の自動保持**

  * バリデーションエラーでフォームを再表示する際、`@user` に既に入力値が保持されているため、再入力の手間を省くことができます。

### なぜ `model:` オプションを使うのか？
modelオプションの説明はしましたが、改めてなぜmodelオプションを設定する必要があるのでしょうか。
`model: @user` を指定することで、Rails は 「このフォームは特定のモデルオブジェクト（ここでは `@user`）に紐づくフォームである」 と判断します。
その結果、下記のようなメリットがあります。
* **新規作成と更新の切り替えが自動**

  * `@user` の状態（保存済みか未保存か）に応じて、フォームの送信先が自動で決定されます。
  * 新規作成なら `POST`、更新なら `PATCH` というように、アプリケーション側で明示的に URL や HTTP メソッドを指定する必要がなくなります。
* **パラメータのネスト**

  * フォームの各フィールドは、`params[:user]` のようなネストされたハッシュとして送信されるため、ストロングパラメータでの管理が容易です。
* **コードのシンプルさと保守性**

  * Rails の規約に従うことで、コード量が減り、フォーム作成に伴う煩雑な処理を自動化できます。

### もし `model:` ではなく url: オプションを使う場合
もし `model:` オプションを使わずにフォームを作成する場合は、送信先を明示的に指定する必要があります。
```html
<%= form_with(url: users_path, method: :post) do |f| %>
  ...
<% end %>
```
この方法では、フォーム送信時に生成されるパラメータの名前（例: name="name" など）は自動でネストされず、params の扱いが異なります。
そのため、Rails のストロングパラメータ（`params.require(:user)`）との組み合わせがうまくいかなくなる可能性があります。

### `form_with` と RESTful なアクション
Rails のコントローラでは、RESTful な設計に従い、次のようなアクションを定義します。

* new → 新規作成用のフォームを表示する（`@user = User.new`）
* create → new フォームから送信されたデータで新しいレコードを作成する
* edit → 既存レコードの編集用フォームを表示する（`@user = User.find(params[:id])`）
* update → edit フォームから送信されたデータで既存レコードを更新する

`form_with` は、`model:` オプションを使うことで、`@user` が新規か既存かを自動で判断します。
たとえば、new アクションの場合、`@user` は未保存のオブジェクトなので、フォームは `POST /users` に送信され、create アクションで処理されます。
一方、edit アクションでは、@user は既存のレコードであるため、フォームは` PATCH /users/:id` に送信され、update アクションで処理されます。

## 送信データはどのように送られるのか？
`form_with` で作成されたフォームは、基本的には HTML の `<form>` タグとして出力されます。
たとえば、新規作成フォームの場合、生成される HTML は以下のようになります。

```html
<form action="/users" method="post">
  <input type="text" name="user[name]" id="user_name">
  <input type="email" name="user[email]" id="user_email">
  <input type="password" name="user[password]" id="user_password">
  <input type="submit" value="Create my account" class="btn btn-primary">
</form>
```
このフォームを送信すると、ブラウザは URL エンコードされたデータを HTTP リクエストのボディに含めて送信します。
Rails はその送信データを自動的に解析し、`params` ハッシュとして各コントローラのアクションに渡します。

例えば、上記フォームの送信時には次のような `params` が生成されます。

```ruby
params = {
  user: {
    name: "入力された名前",
    email: "入力されたメールアドレス",
    password: "入力されたパスワード"
  }
}
```
このように、`form_with` によって送信されたデータは `params` として Rails のアクション（create や update）で受け取ることができます。

## まとめ
* `form_with(model: @user)` を使うことで、Rails は `@user` の状態を自動的に判定し、
新規作成の場合は `POST /users`、更新の場合は `PATCH /users/:id` といった適切な設定を自動で行います。

* フォーム内の各フィールドは、`name="user[field]"` として HTML に出力され、
送信時には `params[:user]` という形でサーバー側に渡されます。

* これにより、コントローラ側では Strong Parameters（例: `params.require(:user).permit(:name, :email, :password)`）を利用して
安全にデータを受け取ることができ、RESTful なアプリケーションの構築が容易になります。

* `form_with` は、URL や HTTP メソッド、パラメータのネストなどを自動化することで、
コードの簡潔さと保守性を高める非常に便利なメソッドです。
