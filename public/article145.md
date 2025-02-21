---
title: 【Rails】strong parameters
tags:
  - Ruby
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-02-21T11:47:23+09:00'
id: 77d87dbbdeac72f02509
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。アメリカにて独学でエンジニアを目指している者です。
現在、Railsチュートリアルを用いて学習を進めていますが、Strong Parametersという概念を学びました。
Railsでは、Webアプリケーションのセキュリティ向上やコードの保守性を高めるために「Strong Parameters」という仕組みが導入されています。この記事では、Strong Parametersの背景、役割、具体的な使い方、そして導入するメリットについて詳しく解説します

## なぜStrong Parametersが必要なのか
Railsでは、ユーザーから送信されたパラメータを使ってモデルの属性を一括で設定する「マスアサインメント」がよく利用されます。たとえば、以下のようなコードです。
```ruby
def create
  @user = User.new(params[:user])
  if @user.save
    # 保存成功時の処理
  else
    render 'new', status: :unprocessable_entity
  end
end
```
このコードでは、`params[:user]` に含まれるすべての値がUserモデルにセットされます。
しかし、もしリクエストに悪意のあるパラメータ（例: `admin: true` や `role: "admin"`）が含まれていた場合、意図しない属性が更新され、セキュリティ上の問題が発生する可能性があります。

そこで、Rails 4以降、Strong Parametersが導入され、コントローラー側で受け取るパラメータを明示的にホワイトリスト形式で指定することで、このようなマスアサインメント脆弱性を防ぐ仕組みが提供されました。

## Strong Parametersの基本的な使い方
strong parametersについては漠然とわかったと思うので、続いてそれの導入方法について記述していきたいと思います
### 1. 必須パラメータの指定 (require)
まず、`params`ハッシュから特定のキー（例えば`user`）が必ず存在することを保証します。
これにより、リクエストにそのキーが含まれていない場合、早期にエラーが発生します。
```ruby
def user_params
  params.require(:user)
end
```

### 2. 許可する属性の指定 (permit)
次に、`user`パラメータの中から、実際に更新または作成に利用する属性のみを明示的に許可します。
たとえば、ユーザーの名前とメールアドレスのみを許可する場合は以下のように記述します。

```ruby
def user_params
  params.require(:user).permit(:name, :email)
end
```
これにより、もしリクエストに`admin: true`のようなパラメータが含まれていた場合でも、自動的に無視されるため、予期しない属性の更新を防ぐことができます。

### 3. コントローラーでの適用
Strong Parametersを利用することで、コントローラーのコードは以下のようにシンプルかつ安全になります。

```ruby
def create
  @user = User.new(user_params)
  if @user.save
    redirect_to @user, notice: "ユーザーが正常に作成されました。"
  else
    render 'new', status: :unprocessable_entity
  end
end

private

def user_params
  params.require(:user).permit(:name, :email)
end
```

`user_params`メソッドを`private`内に入れている理由はいくつかあります

1. コントローラーのアクションと内部メソッドの分離
Rails のコントローラーでは、`public` なメソッドは HTTP リクエストに対してアクションとして呼び出されます。つまり、外部からリクエストを受けるエンドポイントとなります。
`user_params` のようなヘルパーメソッドは、モデルのパラメータを安全に処理するための内部ロジックであり、外部から直接呼び出される必要はありません。そのため、これらを `private` にすることで、意図しないエンドポイントとして公開されるのを防ぎ、内部実装として隠蔽します。

2. セキュリティとカプセル化
たとえ `user_params` 自体がマスアサインメント脆弱性に対する対策としては機能していても、`public` にしてしまうとコントローラーの外部 API として利用可能になり、予期しない形で呼び出されるリスクがあります。
これを防ぐために、`private` 内に定義して外部アクセスをブロックします。
オブジェクト指向プログラミングの原則の一つに、内部の実装詳細を隠す（カプセル化）という考え方があります。
`user_params` はあくまで内部で使用するヘルパーであるため、`public` インターフェースに含めず、`private` にすることで、コードの見通しや保守性も向上します。

## 実際のシナリオ：攻撃を防ぐための具体例
以下の例は、Strong Parametersを使用していない場合に発生しうるリスクと、その対策を示しています。
理解はしていてもどのように被害が出るかのシナリオを実際に知っておくことで理解度が高まると思います

### リスクのあるコード例
```ruby
def create
  @user = User.new(params[:user])
  if @user.save
    # ユーザー作成成功
  else
    render 'new', status: :unprocessable_entity
  end
end
```
この状態だと、curlなどで以下のようなリクエストを送信することで、admin属性を含むデータが送られてしまいます。
```sh
curl -X POST http://localhost:3000/users \
     -H "Content-Type: application/json" \
     -d '{"user": {"name": "Takeshi", "email": "Takeshi@example.com", "admin": true}}'
```

### 対策済みのコード例
以下はstrong parametersを反映させたコードになります
```ruby
def create
  @user = User.new(user_params)
  if @user.save
    redirect_to @user, notice: "ユーザーが正常に作成されました。"
  else
    render 'new', status: :unprocessable_entity
  end
end

private

def user_params
  params.require(:user).permit(:name, :email)
end
```

この場合、adminパラメータは許可されないため、攻撃者が意図的に管理者権限を付与することはできません。


## まとめ
Strong Parametersは、Railsアプリケーションにおけるパラメータ管理の基礎となる重要な仕組みです。

* セキュリティの向上: 不正なパラメータがモデルに渡らないようにする。
* コードの明確化: どのパラメータが許可されるかを明示することで、メンテナンス性が向上する。
* : 拡張や変更が容易であり、将来のアプリケーションの進化に対応できる。
