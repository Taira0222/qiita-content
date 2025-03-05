---
title: 【Rails】Railsチュートリアル8章を読み終えて
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-05T11:52:02+09:00'
id: b792d906a78766c7280a
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカで独学でエンジニアを目指している者です。
現在、Ruby on Rails Tutorialを使ってRailsを勉強しており、第8章まで読み終えたので、学んだことを忘れないように振り返りの記事を書いてみました。
読んだのはだいぶ前でしたが、理解度がかなり低かったので再度復習した際にこの記事を書いています

---

# 基本的なログイン機構
この章ではログインの仕組み


## セッション
この章ではセッションについての説明と、具体的にSessionsControllerの設計を扱いました
sessionメソッドの具体的な説明は、以前に記事を書いているので割愛しますがこの章で作成した`SessionsController`はセッションを使用してログインとログアウトの仕組みを管理しようという意図でそういった名前にしたのかなと思いました
最初はsessionメソッドとSessionsControllerが出てきてどのように関係しているのか考えていましたが、見当違いでした。

### ルーティングの設定
ルーティングを設定するために、`rails generate controller Sessions new`にて`Sessions`コントローラーを作成した後ルーティングを設定します
UsersControllerの際はRESTfulな設計にするために `resource :users`としましたが、今回はログインをするためのnew(GET),create(POST)とログインに必要なdestroy(DELETE)を設定しました

```ruby
Rails.application.routes.draw do
 root "static_pages#home"
 get "/help", to:"static_pages#help"
 get "/about", to: "static_pages#about"
 get "/contact",to: "static_pages#contact"
 get "/signup", to:"users#new"
 get "/login", to: "sessions#new"
 post "/login", to:"sessions#create"
 delete "/logout", to: "sessions#destroy"
 resources :users
 end
```

### ログインフォームの作成
Userの会員登録の際にも使用した`form_with`を`SessionsController`のviewの`new.html.erb`に定義しました。
`form_with`の引数が`model:@user`ではなく、`login_path, scope: :session`に指定しています。
これはactionが`login_path`つまりcreateアクションのPOSTリクエストであることを示しています
ちなみに`scope: :session`はHTTPリクエストとしてparamsに値を渡す際にsessionという名前を付けているという意味合いがあって、後に出てくるsessionメソッドとはまったく別物です

### SessionsControllerのアクションの設定(create)
ここからは少しずつですがSessionsControllerのコントローラーを作成していきます。
必要なアクションはnew,create,destroyですが、newは主にviewsの表示に使用されているのだけなので現時点ではアクションの定義は不要です。

```ruby
class SessionsController < ApplicationController
  def create
      user = User.find_by(email: params[:session][:email].downcase) # 入力されたemailと同じデータがDB内にあるか
      if user&.authenticate(params[:session][:password]) # そのuserのPWが正しいか
        reset_session #session id を更新してセッション固定を防止
        log_in user
        redirect_to user
      else
      # エラーメッセージを作成する
        flash.now[:danger] = 'Invalid email/password combination' 
        render 'new', status: :unprocessable_entity
      end
  end
end
```
createアクションの流れとしては
1. DBからparamsのセッションのemailに該当するものがあるかを確認し、それをuserと定義
2. userが存在し、Userモデルで設定した`によって使用できるようになった`authenticate`メソッドを使用してPWが正しいか確認
3. 2がtrueであれば、セッション固定を防ぐために`reset_session`を使用しセッションをリセットする
4. SessionHelperに定義したlog_inメソッド、引数をuserとして呼び出す。ここでセッションに`session[:user_id] = user.id`としてユーザーIDが登録される
5. `redirect_to user`によって`User#show`が呼び出されます。違うページに遷移する際には`redirect_to`を使用します
6. 2がfalseの場合、flashを使用します。flashだけだと次のリクエストまでエラーメッセージを表示してしまいますが、flash.nowなら今のリクエストまでしかメッセージを持たないのでエラーを表示させる場合、renderで再度そのページを表示させるケースが多い(新たにリクエストを送らない)ので、flash.nowを使用する
7. Sessionsのnewアクションのviewを表示しています。この時:unprocessable_entityはリクエストが正しいけれど、意味的に誤りがある422ステータスコードを表示するようにしています

### スマホ用のビジュアルの調整
スマホサイズか否かはブラウザの開発モードにて見ることができますが、スマホサイズになるとレイアウトが崩れます。
そこでハンバーガーメニューという三本線のよくあるメニューを導入しました

```html:_header.html.erb
<header class="navbar navbar-fixed-top navbar-inverse">
    <div class="container">
    <%= link_to "sample app", root_path, id:"logo"%>
        <nav>
             <div class="navbar-header"> <!--スマホ用のハンバーガーメニューの設定 -->
                <button id="hamburger" type="button" class="navbar-toggle collapsed">　<!--collapsed によって閉じられていることを明示 -->
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span> <!--これでハンバーガーメニューの1本分 -->
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span><!--これが3つでハンバーガーメニューになる -->
                </button>
            </div>
            <ul id="navbar-menu" class="nav navbar-nav navbar-right collapse navbar-collapse">　<!--ハンバーガーメニューによって隠されるメニュー -->
                <li><%= link_to "Home", root_path %></li>
                <li><%= link_to "Help", help_path %></li>
                <% if logged_in? %>　<!--ログイン状態なら表示されているメニュー -->
                        <li><%= link_to "Users",'#' %></li>
                        <li class= "dropdown"><!--Accountにドロップダウンがついている -->
                            <a href= "#" id= "account" class= "dropdown-toggle">
                                Account <b class= "caret"></b>
                            </a>
                            <ul id="dropdown-menu" class="dropdown-menu"><!--ドロップダウンによって隠されているメニュー -->
                                <li><%= link_to "Profile",current_user %></li>
                                <li><%= link_to "Settings", '#' %></li>
                                <li class="divider"></li>
                                <li>
                                    <%= link_to "Logout",logout_path, data:{ "turbo-method": :delete } %>
                                </li>
                            </ul>
                        </li>
                <% else %><!--ログインしていない場合に表示されているメニュー -->
                    <li><%= link_to "Log in", login_path %></li>
                <% end %>
            </ul>
        </nav>
    </div>
</header>
```
ログインの状態ならば、Home,Help,Accountが表示され、Accountにはドロップダウンがついておりそれを押すとProfile,Settings,Logoutリンクがあります。スマホで表示した場合は、`<ul id="navbar-menu" class="nav navbar-nav navbar-right collapse navbar-collapse">`のcollapseによって上記のメニューが隠れている状態です

ログインしていない場合のヘッダーは、Home,Help,Log inのみとなります

## JavaScriptを反映させる
上記のHTML.ERBファイルへ実際にクリックするとJSが反映させるようにJSファイルを書く必要があります
そのまま書くと違う言語のため互換性がないので、importmapというライブラリを使用します
JSを使う前に
1. Gemfileに`gem "turbo-rails", "1.4.0"`と記載(versionはRailsチュートリアルのものを記載している)
2. `app/assets/config/manifest.js`(なければ新規作成)に以下のように記入する。
```js
 //=link_tree../images
 //=link_directory ../stylesheets.css 
 //=link_tree../../javascript.js   //追加
 //=link_tree../../../vendor/javascript.js  //追加
```
ここで注意点ですが、もし`vendor/javascript.js`がなければ追加しないと、ブラウザがJSを正常に読み込んでくれません。
作成する場所について、sample_appがルートディレクトリならその直下に作成してください(`/vendor/javascript.js`)
3. `app/javascript/custom`ディレクトリを作成。`app/javascript/custom/menu.js`も作成して実装のメインとなるコードをmenu.jsに書いていく
4. `config/importmap.rb`に以下を記載
```ruby
 pin "application",preload:true
 pin "@hotwired/turbo-rails", to:"turbo.min.js", preload: true
 pin "@hotwired/stimulus", to:"stimulus.min.js", preload: true
 pin "@hotwired/stimulus-loading",to: "stimulus-loading.js",preload:true
 pin_all_from "app/javascript/controllers",under:"controllers"
 pin_all_from "app/javascript/custom", under: "custom"
```
これも2の時同様で`app/javascript/controllers`ディレクトリが存在しない場合はこれもエラーが出ます。
私はまだこのディレクトリを使用していないので一旦はコメントアウトしています。
6. `app/javascript/application.js`に以下を記載
```js
 // Configure your import map in config/importmap.rb.
 // Read more: https://github.com/rails/importmap-rails
 import "@hotwired/turbo-rails"
 import "controllers"
 import "custom/menu"
```
`application.scss`の時同様ですが、`application.js`がまとめて読み込むしようとなっているようです

ここまで設定して始めてコードを書きます
```js:menu.js
//メニュー操作

//トグルリスナーを追加する
function addToggleListener(selected_id, menu_id, toggle_class) {
    let selected_element = document.querySelector(`#${selected_id}`);
    selected_element.addEventListener("click", function(event) {
        event.preventDefault();
        let menu = document.querySelector(`#${menu_id}`);
        menu.classList.toggle(toggle_class);
    });
}

// クリックをリッスンするトグルリスナーを追加する
document.addEventListener("turbo:load", function() {
    addToggleListener("hamburger", "navbar-menu", "collapse");
    addToggleListener("account", "dropdown-menu", "active");
});

```
DRY法則に乗っ取り演習で`addToggleListener`を作成しクリックされた場合に、以下のようになります
1. ハンバーガーメニューが表示されるようになる
2. ドロップダウンメニューが表示されるようになる
`menu.classList.toggle`のようにtoggleメソッドを使用しているので、`collapse`のように最初に書いてあった場合はクリックすることでそれを削除することができます。


### ログインのテスト
ここまで出来たらログインのテストを行います。
6章で出てきたfixtureのusers.ymlはテストの時に使用する変数を指定できるものなのでここで使用します。
しかし、テスト時には`has_secure_password`によるパスワードのハッシュ化は行われないので自分で作成する必要があります
```ruby:user.rb
class User < ApplicationRecord 
  before_save{ email.downcase!}
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  #渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost:cost)
  end
end

```
これを以下のfixtureのusers.ymlに定義します
```yml
 michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>
```

ここでさっそくテストを書いていきますが、今回はloginのテストをメインで行っていたのでそれのみに触れます
```ruby
require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
end

class InvalidPasswordTest < UsersLogin
  test "login path" do
    get login_path
    assert_template 'sessions/new'
  end
  test "login with valid email/invalid password" do
    post login_path, params: { session: { email: @user.email, password: "invalid" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

class ValidLogin < UsersLogin
  def setup
    super
    post login_path, params: { session: { email: @user.email, password: 'password' } }
  end
end

class ValidLoginTest < ValidLogin
  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "redirect after login" do
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

class Logout < ValidLogin
  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout
  test "successful logout"do
    assert_not is_logged_in?
    assert_response :see_other　# 見慣れない
    assert_redirected_to root_url
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count:0
  end
end
```

このテストはそれぞれ、ログインがうまくいくテスト、うまくいかないテスト、ログアウトがうまく行くテスト、行かないテストの計4つを検証しています。
この中でしいて気になるとすれば、見慣れないとコメントされている`:see_other`というHTTPリクエストです。
```ruby:sessions_controller.rb
  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
```
これは`SessionsController`でも定義されており、`destroy` アクションは `DELETE` リクエストによって呼ばれるため、リダイレクト先に移動した後でブラウザが再読み込み（リロード）された場合、`DELETE` リクエストが再度送信されるリスクがあります。
これを防ぐために、`redirect_to` に `status: :see_other（HTTP 303）`を指定し、リダイレクト先では GET リクエストが実行されるようにしています。



# まとめ
本当はログアウトについても書きたかったのですが、テストの説明をしていたらサクッと説明できたので今回は書きませんでした。
Railsチュートリアルは6章当たりから難しくなってきて8章もかなりやりごたえがあったなと思いました。
皆さん9章から挫折する人も多いと聞くので気を引き締めて9章望みたいと思います。
