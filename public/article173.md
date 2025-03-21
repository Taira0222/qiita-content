---
title: 【Rails】セッションリプレイ攻撃を防ぐ方法
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-21T11:56:33+09:00'
id: 772eadd584257826f92d
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに
こんにちは。アメリカに住みながら独学でエンジニアを目指している taira です。
現在、Railsチュートリアルを使用して学習を進める中で、セッションリプレイ攻撃への対策方法について疑問を持ちました。
そこで、教材に掲載されていたサイトを参考にしながら、自分なりに情報を整理してみました。

## セッションリプレイ攻撃とは
セッションリプレイ攻撃（Session Replay Attack）とは、攻撃者がユーザーとサーバー間の正規通信を盗聴し、その通信内容（特に認証情報やセッション識別子）を記録・保存したうえで、後から再送（リプレイ）することで不正にシステムへアクセスする攻撃手法です。

## なぜ起こるのか
セッションリプレイ攻撃が起こる主な原因として、認証手段をユーザーIDのみで済ませている点が挙げられます。ユーザーIDは単純な数字（たとえば `user_id = 3` など）であるうえ、一度設定すると変更が行われにくい値です。もし cookie が盗まれ、その中にユーザーIDが含まれていれば、ユーザーIDを変更しにくい（もしくは変更しない）ため、対応策がなくなってしまいます。

## `user_id`を認証に使わないという選択肢は？
私が疑問に思ったのは、「ユーザーごとに都度発行されるトークンを使えばいいのではないか」という点でした。しかし `user_id` は主キーとして一意であるため、`User.find` などを使用したデータベース検索の高速化に役立ちます。そのため、システムの効率を考慮すると、`user_id` を認証やユーザー判別に活用するメリットも大きいのです。

## 対策方法
そこで有効なのが、`user_id` に加え、ログインするたびに発行される `session_token` を組み合わせる方法です。以下の例のように、ブラウザを閉じると削除される `session_token` を利用します。

```ruby
def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token  # 追加
end

def current_user
    if (user_id = session[:user_id])
        user = User.find_by(id: user_id)
        if user && session[:session_token] == user.session_token  # 追加
            @current_user = user
        end
    elsif (user_id = cookies.encrypted[:user_id])
        user = User.find_by(id: user_id)
        if user && user.authenticated?(cookies[:remember_token])
            log_in user
            @current_user = user
        end
    end
end
```

モデル側では `session_token` メソッドを利用してハッシュ値を生成する実装が想定されています。これにより、`current_user` の認証時に `session_token` が一致しない限りログイン処理が行われないため、セッションリプレイ攻撃を防ぐことが可能です。

# まとめ
セッションリプレイ攻撃を防ぐには、単純な `user_id` のみの認証だけでなく、都度発行されるトークンを組み合わせて使用することが重要です。効率性の面で `user_id` を使いつつ、セキュリティ対策としては `session_token` を活用することで、システム全体の安全性を向上できます。

## 参照記事
https://techracho.bpsinc.jp/hachi8833/2023_06_02/130443

