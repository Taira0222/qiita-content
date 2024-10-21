---
title: 【SQL】GROUP BYの使い方を理解しておく
tags:
  - SQL
  - 未経験エンジニア
  - 独学
  - GroupBy
  - 未経験からWeb系
private: false
updated_at: '2024-10-21T14:12:30+09:00'
id: cd70d0bb6bacb6eaa51a
organization_url_name: null
slide: false
ignorePublish: false
---
こんにちは、sqlを絶賛勉強しているものです。

本日はGROUP BYについて基礎理解が抜けており理解に時間がかかったのでそれを記事にしたいと思います。

# GROUP BYとは
GROUP BYとは、あるデータベースについてグループを作り集計関数（SUM,AVG,COUNTなど）をすることができます。

GROUP BY を使用する際、SELECT 句に指定できるのは以下の2種類だけです。
1. GROUP BY 句で指定したカラム（下記コードではpurchase_at）
2. 集計関数（SUM, AVG, COUNT など）を使用したカラム

つまり、<strong>GROUP BYは単にグループ化をするだけでなく計算（SUM, AVG, COUNT など）もセットで行うことを想定している</strong>ということです


## Progageでの例

GROUP BYを用いるうえでの注意点を以下のコードを用いて説明しておりました。

```sql:groupby.sql
〇正しいコード
SELECT SUM(price),purchase_at
FROM purchases
GROUP BY purchase_at;

×誤りのコード
SELECT price,purchase_at
FROM purchases
GROUP BY purchase_at;
```

私は上記の誤りのコードを見て、「あれ？purchase_atをGROUP BYでグループ化したのだから、priceでも問題なく出力できるのでは？と考えてました。」

SUMを使用せずにSELECT priceを使用したら以下のように出力されるから何が誤りなのかわかりませんでした。


| price | purchaed_at |
|:-:|:-:|
| 300 | 2024-09-09 |
| 80  | 2024-09-09  |
|   |   |
| 400  | 2024-08-30  |
| 250  | 2024-08-30  |
|   |   |
| 150  | 2024-07-15  |
|120   |2024-07-15   |

## 私が理解できなかったこと

私は以下のことを理解していなかったのでGROUP BYの理解に時間がかかりました。

* SELECTの後ろには集計関数（SUM, AVG, COUNT など）、GROUP BY 句で指定したカラム（下記コードではpurchase_at）しかおけない。
* GROUP BYはグループ化するだけでなく計算もセットに行う。

<br>
特に2つ目の計算もセットに行うということがsqlで初めて学んだことで、今まで扱ってきたデータは計算をしなくてもグループ化することがあったのでとても驚きでした。

上記を踏まえて以下のコードの問題点を見てみましょう。

```sql:groupby.sql
SELECT price,purchase_at
FROM purchases
GROUP BY purchase_at;
```

明らかだと思いますが、集計関数（SUM, AVG, COUNT など）を使用したカラムが含まれていません。

計算を想定しているGROUP BYにふさわしくないコードであるためエラーが出るということです。

# まとめ

今回は私が陥ったGROUP BYの落とし穴について解説しました
SELECTの後ろには集計関数（SUM, AVG, COUNT など）、GROUP BY 句で指定したカラム（下記コードではpurchase_at）しかおけない。

ということについては、文字通り書いていたので私のミスリードですが、計算をセットに行うことを想定していたGROUP BYの特性を知ることができていい勉強になりました。
