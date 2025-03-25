---
title: 【Rails】Railsチュートリアル10章を読み終えて
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-25T11:57:28+09:00'
id: 71875c5099f0d7d5c99c
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに
こんにちは。アメリカに住みながら独学でエンジニアを目指している taira です。
本日はRailsチュートリアル10章を読み終えたので、その内容について自分なりに整理してみようと思いました


## ユーザーを更新する
9章はcookieを使用したRemember me機能の実装でしたが、10章は今まで未実装だったUsersリソース用のRESTアクション等を完成させる章でした

ユーザーを更新するためにはeditアクションとupdateアクションを作っていきます

```ruby
class UsersController <ApplicationController

  def edit
    @user =User.find(params[:id])
  end

  def update
    @user =User.find(params[:id])
    if @user.update(user_params)
      flash[:success]= "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
```

editアクション、updateアクションは上記のように作成しました
updateがうまくいったら、user_path(@user)にリダイレクトし、失敗したら、editのviewを再び呼び起こします
updateメソッドはStrong Parametersを使って、マスアサインメントの脆弱性を防止しています

```ruby 
<% provide(:title,"Edit user") %>
<h1>Update your profile</h1>

<div class="row">
  <div class="col-md-6col-md-offset-3">
    <%= form_with(model:@user)do |f| %>
      <%= render 'shared/error_messages' %>

      <%= f.label :name %>
      <%= f.text_field :name,class:'form-control' %>

      <%= f.label :email %>
      <%= f.email_field :email,class:'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password,class:'form-control' %>

      <%= f.label :password_confirmation, "Confirmation"%>
      <%= f.password_field :password_confirmation,class:'form-control' %>

      <%= f.submit "Save changes", class: "btn btn-primary" %>
    <% end %>

    <div class="gravatar_edit">
      <%= gravatar_for @user %>
      <a href="https://gravatar.com/emails" target="_blank" rel = "noopener">change</a>
    </div>
  </div>
</div>
```

上記は`edit.html.erb`です。`new.html.erb`と同様に`<%= form_with(model:@user)do |f| %>`を使用していますが、ActiveRecordの`new_record?`によって@userが新規ユーザーか否かを見極めて新規作成か編集なのかを見極めています。

`target="_blank"`だけだと古いブラウザなどでは、リンク先のHTMLのwindowオブジェクトを扱うことができてしまい、フィッシングサイトのような悪意のあるリンクに書きかえられる可能性があります。
そこで`rel = noopener`を入れることで、それを防ぐことができます。

## 認可
上記でeditとupdateアクションの大まかな実装はできたのですが、このままでは、ログインしていないユーザー(誰でも)が情報を書きかえることができてしまいます。
また、ログインしてもほかのユーザーが同様に編集できてしまってはまずいので、それについての実装も行いました
さらに、ユーザー体験をあげるために、フレンドリーフォワーディングも実装しました

### ログイン済み・正しいユーザーのみが使用できるようにする

この仕組みを実装するためにbefore_actionメソッドをUsersコントローラー内で実装しました。
これはアクションを行う前に、メソッドを指定することができます。

```ruby
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]


  def edit
  @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

    private

    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

    # before フィルター

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location # フレンドリーフォワーディングの際に使用
        flash[:danger] = 'Please log in'
        redirect_to login_url, status: :see_other
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
end
```
edit・updateアクションを実施する前に、`logged_in_user`によってログイン済みか否かを確認、`correct_user`メソッドによって、ログイン済みのユーザーと`current_user`が一致するか確認しています

```ruby
class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user) , params: { user: {name: @user.name,
                                             email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user) , params: { user: {name: @user.name,
                                              email: @user.email}}
    assert flash.empty?
    assert_redirected_to root_url
  end
end
```

上から順番に以下のテストをしています
1. ログインしていないユーザーが編集した場合
2. ログインしていないユーザーが更新した場合
3. ログイン済みの違うユーザーが編集した場合
4. ログイン済みの違うユーザーが更新した場合

フレンドリーフォワーディングについては以前記事を書いたのでそちらに詳しくまとめています

https://qiita.com/Taira0222/items/3c5098aee72ad63d6ba3


## すべてのユーザーを表示する
ここでは、すべてのユーザーを表示するindexアクションを実装し、gemのfakerとpagenateを実装して効率よくユーザー一覧を表示させます
基本的なコントローラーとビューの実装ではなくfakerとページネーションについて説明していきます

### fakerを使用してユーザーを量産する
gemfileにfakerを実装します。後の説明に使用するページネーションのgemも併せて追加しておきます
```ruby
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.3"

gem "rails", " 7.0.4.3"
gem "bcrypt", "3.1.18"
gem "faker", "2.21.0" # 追加
gem "will_paginate", "3.3.1"　# 追加
gem "bootstrap-will_paginate", "1.0.0"　# 追加
```
bundle installで変更を反映させたのち、`db/seeds.rb`に以下のようにユーザーを作成します
```ruby
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end
```
先ほどGemでインストールしたFakerは名前をランダムで作成してくれます。
データベースをリセットして、上記変更を反映させます。
```
rails db:migrate:reset
rails db:seed
```

これで簡単にユーザーを100人作成することができました

### ページネーション
indexの画面にユーザーが100人一気に表示されたらとても見ずらいと思います。
また、User.allでフルスキャンしていることからその数をできるだけ少なくしたほうがパフォーマンスも向上します。
ページネーションの実装はそこまで難しくありません
```html
<% provide(:title, 'All users') %>
<h1>All users</h1>

<%= will_paginate %>

<ul class = "users">
    <%= render @users%>
</ul>

<%= will_paginate %>
```
```ruby
 def index
    @users = User.paginate(page: params[:page])
  end
```

`will_pagenate`を上下に入れて、コントローラーでpagenateメソッドを使用することで簡単にページネーションを実装することができました

### ユーザー一覧のテスト
ここまで実装できたら、indexの統合テストを実施します
```ruby
require "test_helper"
class UsersIndexTest <ActionDispatch::IntegrationTest
  def setup
    @user =users(:michael)
  end

  test "index including pagination"do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page:1).each do |user|
      assert_select 'a[href=?]',user_path(user), text:user.name
    end
  end
end
```
User.pagenate(page:1)によって30人のユーザー情報があるのでそれをブロック処理してassert_selectでテストしています


## ユーザーを削除する
最後にdestroyアクションを実装します。むやみあたらにほかのユーザーの情報を削除できないように管理者のみが削除できるように設定します。
管理ユーザー実装のために、Usersテーブルにadmin属性(boolean)を追加します
```
rails generate migration add_admin_to_users admin:boolean
```
ここでbooleanはtrueかfalseを値として取ります。これによりadmin?メソッドによって管理ユーザーか否かを確認できるようになりました

次にdestroyアクションを実装します。
```ruby
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in'
      redirect_to login_url, status: :see_other
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url, status: :see_other)unless current_user.admin?
  end
end
```
destroyアクションもログイン済みのユーザーかつ、管理者でないとできないようにしたいのでbefore_actionで設定します

また、destroyのテストも実施します
```ruby
require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test 'index including pagination and delete links' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination',count:2
    first_page_of_users = User.paginate(page:1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]',user_path(user), text:user.name
      unless user == @admin
        assert_select 'a[href=?]',user_path(user), text:'delete'
      end
    end
    assert_difference 'User.count',-1 do
      delete user_path(@non_admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count:0 # <a[href]>にdeleteという文字が存在しない
  end
end
```

管理ユーザーがdestroyアクションを呼び出したら、ユーザーを削除することができ、そうでなければ削除できないのをテスト上で表現しています

## まとめ
10章はほかの画面の実装部分だったため、9章よりはかなり理解しやすかったです。
残すところ4つとなりとても感慨深いですが、これからも着実に進めていきたいと思います
