---
title: 【rails】devise ログイン後のリダイレクト先(after_sign_in_path_for)
tags:
  - Rails
  - devise
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-06-04T12:14:53+09:00'
id: 6ec485304a18a591e07f
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails チュートリアルのアウトプットとしてアプリを製作しています。
ログイン認証は devise を使用しているのですが、初めてということもあり何が何だかわからず、ログイン後のリダイレクト先すらも自分で設定できないでいました。
しかし、ソースコードを見てみるといろいろわかることがあったので、今回はそれについて記事を書いていきます。

- rails 8.0.3
- docker/devcontainer
- devise 4.9

### 1. デフォルトの動作

Devise を使った場合、ユーザーがログインするとデフォルトでは `root_path` にリダイレクトされます。

しかし、アプリによっては

- マイページ（`/users/:id`）に遷移したい
- ダッシュボード（`/dashboard`）に飛ばしたい
  など、リダイレクト先をカスタマイズしたいケースがあります。

---

### 2. `after_sign_in_path_for` メソッドを使う

Devise では、このようなリダイレクト先を `ApplicationController` に定義する `after_sign_in_path_for(resource)` メソッドで上書きできます。

#### 例: ログイン後にダッシュボードに遷移させる

```ruby
class Users::SessionsController < Devise::SessionsController

  private
    def after_sign_in_path_for(resource)
      dashboard_path
    end
end
```

#### 例: ログインユーザーのマイページに遷移させる

```ruby
class Users::SessionsController < Devise::SessionsController
  private
    def after_sign_in_path_for(resource)
      user_path(resource) # resourceはログインしたUserオブジェクト
    end
end
```

---

### 3. 他のリダイレクト関連メソッド

同様に、以下のようなメソッドも存在します。

- `after_sign_out_path_for(resource)`：ログアウト後の遷移先
- `after_sign_up_path_for(resource)`：新規登録後の遷移先

必要に応じて、これらもオーバーライドしましょう。

---

### 4. 注意点

- `after_sign_in_path_for` をオーバーライドする場合、 `super` を呼ばないと Devise 側のロジックは実行されません。完全に自分のロジックで上書きする場合は `super` を呼ぶ必要はありません。
- ルーティングが正しく設定されていないと `NoMethodError` や `RoutingError` が発生するので注意しましょう。

---

### まとめ

Devise では `after_sign_in_path_for` を使うことでログイン後のリダイレクト先を柔軟にカスタマイズできます。ユーザー体験を向上させるために、アプリの仕様に合わせて適切に設定しましょう。
