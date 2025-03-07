---
title: 【Rails】422 unprocessable_entity
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-07T11:53:46+09:00'
id: 84b46451df279377d5bf
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカで独学でエンジニアを目指している者です。
現在Railsチュートリアルを用いて勉強していますが、本日はそこで出てきたHTTPステータスコード 422 Unprocessable Entity について記事にしたいと思います

### 422 Unprocessable Entity の概要

HTTPステータスコード 422 の大まかな意味は以下のとおりです。

- **正しい形式**
  クライアントから送信されたリクエストは、HTTP のプロトコルや文法的には正しい。
- **意味的な誤り**
  しかし、送信されたデータがサーバーの期待する内容と合致しておらず、処理を完了できない。

たとえば、ユーザー登録フォームで必須項目が未入力だったり、数値の範囲が不適切だったりする場合など、リクエスト自体は解釈できても内容が妥当ではないケースに 422 を返すことで、「構文は正しいがデータの意味に問題がある」ことをクライアントに伝えられます。

---

### 422 が用いられる背景

HTTPステータスコードの 4xx 台は主にクライアントに原因があるエラーを示すものですが、その中で 422 はとくに「入力内容の意味的な問題」を表すために設けられています。

#### なぜ 422 なのか？

- **400 Bad Request との違い**
  400 Bad Request はリクエストの構文自体が誤っている場合に使われるのが一般的です。一方 422 Unprocessable Entity は、リクエスト形式（ヘッダーやメソッド、JSON/XML の構造など）は正しくても、内容がサーバーのバリデーション要件などに合致しないために処理不可能な場合に使われます。

つまり 422 は「リクエストそのものは解釈できるが、入力データがサーバーの要求を満たしておらず、処理を完了できない」ことをクライアントに伝えるコードと言えます。

---

### Ruby on Rails における 422 の利用例

Rails では、認証失敗やモデルのバリデーションエラーなど、入力内容が正しくない場合に 422 を返すことが多いです。以下に、よくある２つのケースを示します。

#### ユーザー認証エラー時の例

ログインフォームでメールアドレスまたはパスワードが誤っている場合、セッションの作成に失敗するため 422 を返すことで「入力内容が不正で処理不能である」ことを示します。

```ruby
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session    # セッション固定攻撃対策
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
```

上記の `render 'new', status: :unprocessable_entity` によって、クライアントは「認証用リクエストの形式は合っているが、実際の認証情報に誤りがある」状態と認識できます。

#### バリデーションエラー時の例

ユーザー登録やリソース作成時にモデルのバリデーションが失敗した場合も、422 が最適です。

```ruby
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User created successfully"
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
```

モデルのバリデーションに失敗すると `@user.errors` にエラー内容が詰め込まれますが、その際に 422 を返すことで、クライアント側（フロントエンドや他システム）は入力項目を再度確認・修正するよう誘導できます。

---

### 422 を返す意義とクライアント側の対応

422 Unprocessable Entity を適切に返すことで、以下のメリットがあります。

1. **明確なエラー判別**
   400 Bad Request などの汎用的なステータスコードでは区別しづらい「入力値が妥当でない」ケースを明示できます。
2. **ユーザーへの適切なフィードバック**
   エラーの詳細（バリデーションメッセージなど）をレスポンスに含めることで、ユーザーはどの入力が問題だったかをすぐに把握できます。
3. **API連携における再送制御**
   外部サービス連携などで、リトライが必要か否かを判断しやすくなります。422 は入力データ修正が必要であることを示すため、ただちに再送してもエラーが繰り返される可能性が高いことをクライアント側が理解できます。

クライアント実装では、422 を受け取った場合はフォーム入力の再チェックやユーザーへの修正指示を行うなど、再送の前にデータの修正を要求するといった流れが推奨されます。

---

### まとめ

HTTPステータスコード 422 Unprocessable Entity は、リクエストが文法的には正しいものの、データ内容の不備やバリデーションエラーにより処理を継続できない場合に返すコードです。特に Ruby on Rails では認証エラーやバリデーションエラー時にこのステータスを返す実装が一般的で、クライアントに正しくエラー状況を伝えるうえで非常に有用といえます。

