---
title: 【Rails】renderとredirect_toの使い分け
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-02-23T11:51:08+09:00'
id: e342633d9a25c4db23e1
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカにて独学でエンジニアを目指している者です。
Railsでコントローラを実装していると、ビューを表示させたいときには`render`、別のアクションに転送したいときには`redirect_to`を使う場面がよくあります。
この2つのメソッドは見た目こそ同じように「画面に何かを返す」ように見えますが役割や仕組みが大きく異なります。
本記事では、Railsにおける`render`と`redirect_to`の違い、使い分けのポイント、そしてベストプラクティスについて解説します。

---

### `render`と`redirect_to`の基本的な違い

#### 1. `render`とは？

- **その場でビューを表示**する。
- 同一リクエスト内でテンプレートをレンダリング（描画）するので、**リクエストは新規に発行されない**。
- **URLは変わらない**。例えば`/users`にPOSTリクエストを送信している最中に`render :new`を行うと、ブラウザのアドレスバーは依然として`/users`（POST送信元）のままです。

##### 典型的な使用例：バリデーションエラー時の再表示

```ruby
def create
  @user = User.new(user_params)
  if @user.save
    # 省略
  else
    # フォームの入力不備があればnewフォーム画面を再表示
    render :new, status: :unprocessable_entity
  end
end
```

上記のように**フォーム送信後にエラーがあった場合**、すでに入力された値やエラーメッセージを表示するために`render :new`を使います。入力値を再利用できるように、同じリクエスト内でテンプレートを描画しているわけです。

#### 2. `redirect_to`とは？

- **ブラウザに対して別のURLを再度リクエスト**するよう命じる。
- HTTPステータスコードは通常「302 Found」や「303 See Other」(Railsによってリクエストの種類に応じて使い分け) が返され、ブラウザはその指示に従って**別のアクションをGETリクエスト**として再度呼び出します。
- **URLが変わる**。たとえば`redirect_to @user`と書くと、`/users/:id`（showアクション）へ転送されます。

##### 典型的な使用例：リソースの作成や更新が成功した後

```ruby
def create
  @user = User.new(user_params)
  if @user.save
    flash[:success] = 'Welcome to the App!'
    redirect_to @user  # `/users/:id` へリダイレクト
  else
    render :new, status: :unprocessable_entity
  end
end
```

新規作成が成功した場合などに`redirect_to`を使うのは、**画面を再表示した際に再度POST（またはPATCH/PUT等）が送信される二重投稿を防ぐ**ためです。これは**POST/REDIRECT/GETパターン**と呼ばれ、実務でもよく使われます。

---

### 使い分けの理由

#### 1. 二重投稿（POSTリクエストの再送信）防止

ユーザーがフォームを送信するときには、サーバーにPOSTリクエストが送られます。もしエラーではなく成功時にそのまま`render`を使うと、ユーザーがページを更新（リロード）しただけで再度同じPOSTリクエストが送信されてしまいます。
これにより**同じデータが重複して作成されるリスク**があるため、成功時は`redirect_to`で別のアクションへ飛ばし、ブラウザに**GETリクエストを再送信させる**ことがRailsの流儀になっています。

#### 2. ユーザー体験（UX）の向上

`redirect_to`するとURLが正しくリソースを表すもの（例：`/users/1`）になるので、ユーザーがブックマークしたり、URLを共有したりするときに便利です。\
`render`の場合はURLが変わらず、フォーム送信時にエラーが出てもアドレスバーのURLが変わらないため、**ユーザーにとってはどの画面を見ているかわかりにくい**ことがあります。しかし、入力エラーの際はその場でフォームとエラーメッセージを再表示したいので、`render :new`を用いるのは自然です（また別のURLにリダイレクトしてしまうと、エラー情報を渡す手間が増えてしまいます）。

#### 3. RESTfulな設計

Railsの基本原則は**RESTfulな設計**です。

- 新規作成→POSTを受けて→`create`アクション→成功時に`redirect_to show`へ
- 更新→PATCH/PUTを受けて→`update`アクション→成功時に`redirect_to show`へ

こうした一連の操作はAPIとしても分かりやすく、**コントローラ内のフロー**も整理しやすくなります。

---

### サンプルコード：`render`と`redirect_to`の使い所

ここでは簡単なUserモデルを例に示します。

```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 成功時：フラッシュメッセージをセットし、showアクションへリダイレクト
      flash[:notice] = "User was successfully created."
      redirect_to @user
    else
      # 失敗時：newアクションのフォーム画面を再表示
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
```

- **成功（バリデーション通過）**

  - `@user.save`がtrueを返す
  - `flash[:notice]`にメッセージを設定
  - `redirect_to @user`が呼ばれ、ブラウザは`/users/:id`へGETリクエストを送る
  - コントローラは`show`アクションが呼ばれ、詳細ページを表示

- **失敗（バリデーションNG）**

  - `@user.save`がfalseを返す
  - `render :new`を呼び出し、同じリクエスト内で`new`ビューを描画
  - `@user`にはエラー情報が入っているため、ビューでエラーメッセージが表示される
  - URLは`/users`（POST送信先）のまま変わらないが、この場合はユーザーの入力エラーを即座に表示できるため利便性が高い

---

### よくある質問と注意点

#### Q1. 成功時に`render :show`ではダメなの？

- 成功後に`render :show`を使うことは技術的には可能ですが、**フォームの二重投稿を防げない**などの問題が起きます。また、ユーザーのブラウザのURLがPOSTのままになり、リロードするとまたPOSTが実行される可能性があります。したがって\*\*`redirect_to`を使うのがベストプラクティス\*\*です。

#### Q2. バリデーションエラーのときに`redirect_to`したい

- エラー情報や入力途中のフォーム内容を引き継ぐのが難しくなります。通常はリダイレクト先でエラーメッセージを表示するための仕組みが必要になるでしょう。
Railsの一般的なパターンは、エラー時は`render :new`や`render :edit`で同じリクエスト内でエラー表示をすることです。

#### Q3. `render`と`redirect_to`どちらがパフォーマンスに優れているの？

- どちらを選ぶかは**アプリのフロー**で決めるべきで、パフォーマンスが決定的な要因になることはほとんどありません。むしろ**二重送信**や**ユーザーの操作性**を考慮した上で選択するのが重要です。

#### Q4. `redirect_to`先を動的に変更したい

- Railsでは`redirect_to user_path(@user)`のようにヘルパーメソッドを使ってURLを動的に生成できます。`redirect_to @user`はこのヘルパーを裏で使っているので、オブジェクトを渡すだけで適切なパスを計算してくれます。

---

### まとめ

- **`render`**: 同じリクエスト内でテンプレートを描画。URLはそのまま。バリデーションエラー時のフォーム再表示などに使う。
- **`redirect_to`**: ブラウザが改めて別のURLにアクセス。URLが変化し、二重投稿防止にもなる。成功時の処理や別ページへの誘導に使う。

Railsでは「失敗時は`render`、成功時は`redirect_to`」が基本パターンと言えます。これはユーザー体験向上やデータの重複作成防止につながるためです。


