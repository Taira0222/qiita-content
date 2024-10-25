---
title: 【SQL】Nullって意外とややこしい？
tags:
  - SQL
  - 'NULL'
  - 未経験エンジニア
  - 未経験からWeb系
private: false
updated_at: '2024-10-05T07:13:10+09:00'
id: 9a2d3f482007703f154f
organization_url_name: null
slide: false
ignorePublish: false
---
こんにちは、JSの勉強がひと段落ついたので現在SQLの勉強をしています。

その中でもNullってわかっていないと構文を覚えるのにも作業を進めていくにも大変と思ったので記事にしようと思いました。

# 1.Nullってそもそも何？
Nullというのは、データベース上でデータの中に値が存在しないことを指します。
下の画像でいうと黄色に着色されているところは値がありません。

![purchases テーブル](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/ec81d3dc-b1f5-2d2a-2573-de56d717ff63.png)

この場合は値がNullであるといいます。
ちなみに、Nullはラテン語由来らしく無って意味らしいです。
上記のデータはpurchasesテーブルとしておきます。

# 2.Nullを抽出したい場合
上記のpurchases テーブルからNullを含む行を抽出したい場合は以下のように出力します。

```sql:null.sql
SELECT * FROM purchases
WHERE price IS NULL;
```

以下のように出力されます
<br>
![画像2.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/2a7b1376-70ba-e444-28aa-91368d919e54.png)
<br>
では、理解を深めるためにpurchases テーブルpriceが300の行を主力してみましょう

```sql:null.sql
SELECT * FROM purchases
WHERE price =300 ;
```
<br>
下記のように出力することができました。

![画像3.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/73daa756-85c7-92ab-97fc-047f8cf5f6a2.png)
<br>

ここで疑問に思うのが「300のような値を指定して主力することができるなら、price=Null;にしても出力できるのでは？」ということです。
値がないものをNullと定義しているなら＝にしてどうにか参照できそうですよね。

ここでもう一度Nullの定義に戻りましょう。
Nullとはセルの中に値がないものを指します。つまり値がないものを参照してもわからないということです。

例えば、google レンズなどの画像認識機能を使わずに以下の写真を見てください。

![S__18227202.jpg](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/e4fd8cf5-1bde-3532-f2f2-49577e221fd6.jpeg)

「この写真に乗っている場所は埼玉県ですか？」Yes or Noで答えてと言われた場合困りますよね。左側に白州蒸留所のマークがあるのでわかる方にはわかりそうですが、、ｗ

コンピューター上ではほぼ同じことが起きています。

コンピューターは今回の場合のように写真などの情報も渡されず、WHERE price =NULL; つまり「値がないものを参照して」と言われてもないものを参照することができないのです。

つまりNullの場合は＝が使えないのでかわりに　IS NULL を利用するというわけですね。納得！

## Nullには等号だけでなく等号否定や不等号も使えない
上記のイメージがついた方なら大丈夫かと思いますが、等号同様不等号も使えません。

# 3.Null以外を抽出したい場合
Null以外を出力したい場合は以下のコードを使用します。
<br>

```sql:null.sql
SELECT * FROM purchases
WHERE price IS NOT NULL;
```
以下のように出力できます
![画像4.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/04dac598-5f44-927a-6a66-89c4727b1176.png)


上記のNullの説明でしましたが＝が使えなので代わりにIS NOT NULLを使用しています。

# 4.Nullと空文字の違いについて
結論から伝えるとNullと空文字は別物です。
例えば、今ここに真空の容器と空気が入っている普通の容器があったとします。

真空の容器は言うまでもありませんが空気をすべて抜いているので中には何も入っていません。

一方で空気の入っている普通の容器は、中に空気（窒素約80％、酸素約18％）が入っているので一見からですが中には空気が入っています。

![画像5.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/ebe8d10e-5ebe-0603-c9fd-f7dd03c70e4e.png)

つまり、Nullは値が何もないのに対し、空文字は長さ0の文字列、すなわち、空のデータが存在すると表現することができます。

もっと踏み込むとNullは数字列の空白、空文字は文字列の空白です。

以下のpurchases1で試しに空文字を出力してみましょう。

![文字列.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/a7de6183-fa2c-1888-1b2b-bab4656afdf3.png)
<br>

```sql:null.sql
SELECT name
From purchases 
WHERE name ='';
```

出力結果は0となります。意外かもしれませんが上記の通り空文字には長さ0の文字列が入っているということになります

# まとめ
今回はNullについての考え方についてまとめました。正確な概念は若干間違っているかもしれませんがイメージについてはあっているかと思います。

重大なミスがあれば指摘していただけるとありがたいです。
どんどん積極的にアップデートしていきたいと思います。
