---
title: 【Ruby】Procとlambdaの違いについて整理してみた
tags:
  - Ruby
  - 初心者
  - Proc
  - Lamda
  - 未経験エンジニア
private: false
updated_at: '2024-12-09T06:13:41+09:00'
id: 8220db346125eb613f0e
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。

最近RubyでブロックやProc、lambdaを勉強する中で、「Procとlambdaって何がどう違うの？」という疑問が湧いてきました。

書籍やドキュメントを読むと、「lambdaはメソッドに近い挙動で、Procはブロックをオブジェクト化したもの」という説明をよく見かけますが、なぜそう言われるのか、特に`return`や引数処理の違いがどのように影響するのか、いまいちピンとこない方もいるかもしれません。

そこで今回は、**引数チェック**と**returnの動き**の2つの観点から、Procとlambdaの違いを整理してみようと思います。


### 引数チェックの挙動

Procとlambdaは、引数に対する取り扱いが異なります。この違いは、lambdaが「メソッド的」であることを示す一つの重要なポイントです。

#### Procの場合

- 引数の個数が足りなかったり多すぎたりしてもエラーになりません。
- 余った引数は無視され、足りない部分は`nil`が補われます。
- 柔軟に呼び出せるのが特徴です。

#### lambdaの場合

- lambdaはメソッドと同様、引数の数が合わないとエラーを発生させます。
- 厳密に定義どおりの引数を受け取らなければなりません。

#### 具体例

##### Procでの挙動

```ruby
my_proc = Proc.new { |a, b| [a, b] }

p my_proc.call(1)       # => [1, nil] (引数不足はnilで補われる)
p my_proc.call(1, 2, 3) # => [1, 2]   (余分な引数は無視される)
```

Procの場合、引数が合わなくてもエラーにならず、柔軟な処理が行われることがわかります。

##### lambdaでの挙動

```ruby
my_lambda = lambda { |a, b| [a, b] }

p my_lambda.call(1, 2)   # => [1, 2] 通常はこれでOK
# p my_lambda.call(1)    # => ArgumentError (wrong number of arguments (given 1, expected 2))
# p my_lambda.call(1, 2, 3) # => ArgumentError (wrong number of arguments (given 3, expected 2))
```

lambdaは引数が足りなかったり多すぎたりするとエラーを出します。この挙動は、メソッドに引数を渡す場合と同じです。

---

### returnの挙動の違い

続いて、`return`キーワードを使ったときの違いを見てみましょう。ここが、Procとlambdaを混同しないための重要ポイントです。

#### Procの場合

- `Proc.new`で作ったProcは、ブロックをオブジェクト化したものです。
- もともとブロック内で`return`を書くと、そのブロックを含むメソッド全体から抜け出そうとする性質があります。
- Procはこの特性を受け継いでいるため、内部で`return`を書くと、そのProcが定義されたメソッドを巻き込んで終了させようとします。

#### lambdaの場合

- lambdaは`return`を書いてもlambda内部だけで完結し、外側のメソッドには影響しません。
- lambdaはメソッドに近い挙動を持つため、`return`はあくまで「lambdaという小さな関数」からの脱出で終わります。

#### 具体例

##### Procでの`return`問題

```ruby
def power_of(n)
  Proc.new do |x|
    return x ** n  # 注意：ここでreturnするとpower_ofメソッドから抜けようとする
  end
end

cube = power_of(3)
cube.call(5) # => エラー発生
```
Procはブロックをとっていますが、メソッドというよりはオブジェクトして扱われます。
このように、Procでは`return`が外側のメソッドにまで影響を及ぼします。

##### lambdaでの問題が起きない例

```ruby
def power_of(n)
  lambda do |x|
    return x ** n  # lambda内でのreturnはlambda自身からの脱出に留まる
  end
end

cube = power_of(3)
p cube.call(5) # => 125 (問題なく動く)
```

lambdaの場合、`return`してもlambda内部で完結するため、外側の`power_of`メソッドには影響しません。すでに終了している`power_of`を巻き込むことがないので、エラーは起きません。

---

### まとめ

#### 引数チェックの違い

- **Proc**は引数の数に対して緩く、**lambda**は引数数が厳密。
- lambdaはメソッドと同じように引数の整合性を求めるため、ここで「lambdaはメソッド的」と言えます。

#### returnの違い

- **Proc**は`return`で外側のメソッドからも抜けようとしてしまいます。
- **lambda**は`return`しても内部だけで処理を終え、外側のメソッドには影響しません。この点でもlambdaはメソッド的なふるまいと言えます。


