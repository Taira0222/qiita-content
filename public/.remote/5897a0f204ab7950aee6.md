---
title: 【Ruby】今日書いたコードの振り返り(繰り返し)#9
tags:
  - Ruby
  - map
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-25T10:32:15+09:00'
id: 5897a0f204ab7950aee6
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指しているものです。
前回も繰り返しの問題を解きましたが、難易度がかなり低めだったのでもう少し難しめの繰り返しの問題に挑戦してみました。

## 問題の内容
## 概要
N個の整数が与えられます。この整数配列を3回の繰り返し処理（3段階のフィルタリングと変換）を通して処理し、最終的に残った整数を特定の条件で出力してください。

## 要件
1. 初期配列にはN個の整数が格納されている。
2. 第1段階の繰り返し処理：
    * 配列内の整数をすべてチェックし、10以上の整数のみを残し、他は除外する。
3. 第2段階の繰り返し処理：
    * 残った整数すべてに +5 を加算する。
    * 加算後、50以上の整数のみを残し、それ以下は除外する。
4. 第3段階の繰り返し処理：
    * 残った整数がある場合、その平均値(平均は小数点以下切り捨て)を求める。
    * 平均以上の整数のみを最終的な結果として残し、平均未満の整数は除外する。
5. 最終的に残った整数を、昇順にソートして出力する。

### 実行例
```ruby
process_numbers([3, 12, 49, 10, 55, 7, 100])  
# 第1段階後: [12, 49, 10, 55, 100] (10以上)
# 第2段階後: [17, 54, 15, 60, 105] → 50以上: [54, 60, 105]
# 第3段階後: 平均は(54+60+105)=219/3=73, 73以上は[105]
# 出力: 105
```

### 私が初めて書いたコード
今回の問題はそこまで苦戦せず解くことができました
```ruby
def process_numbers(number_array)  
    # 第1段階
    first_process = number_array.select{|number| number >= 10}

    # 第2段階
    second_process = first_process.map{|number| number += 5}.select{|number| number >= 50}

    # 第3段階
    second_average = second_process.sum.fdiv(second_process.size)
    final_process = second_process.select{|number| number > second_average}
    
    p final_process
end

process_numbers([3, 12, 49, 10, 55, 7, 100])
```
上記のコードではおおむね機能を実装できていますが、いくつかミスがありました
1. 「平均以上」ではなく「平均より大きい」を使っている(第3段落 second_average)
2. 平均値が「小数点以下切り捨て」になっていない(`second_process.sum.fdiv(second_process.size)`の部分)
fdiv によって浮動小数で計算されますが、問題文では「小数点以下切り捨て」を求めているので、それの実装が漏れていました
3. ソートや出力形式
要件で「昇順にソートして出力」とありますが、最後は `p final_process`としか書いておらずソートをしていなかった。

### 上記の改善コード
上記のミスを踏まえてコードを書いてみました
```ruby
def process_numbers(number_array)  
    # 第1段落の繰り返し処理
    first_process = number_array.select{|number| number >= 10}

    # 第2段落の繰り返し処理
    second_process = first_process.map{|number| number+= 5}.select{|number| number>= 50}

    # 第3段落の繰り返し処理
    second_average = second_process.sum.fdiv(second_process.size).round(half: :down)
    final_process = second_process.select{|number| number >= second_average}
    
    final_process.sort.each {|i| puts i}

end
process_numbers([3, 12, 49, 10, 55, 7, 100])  
```

### ほかの解答例
上記はわたしが考えてたコードですが、Chatgptが考えたコードはまた別でした
```ruby
def process_numbers(nums)
  # 第1段階: 10以上のみ
  nums = nums.select { |x| x >= 10 }

  # 第2段階: 全てに+5し、50以上のみ残す
  nums = nums.map { |x| x + 5 }.select { |x| x >= 50 }

  # 第3段階: 平均値以上のみ残す
  unless nums.empty?
    avg = (nums.sum / nums.size) # 小数点切り捨てを自然に行う整数除算
    nums = nums.select { |x| x >= avg }
  end

  # 昇順にソートして出力
  nums.sort.each { |x| puts x }
end

# 実行例
process_numbers([3, 12, 49, 10, 55, 7, 100])  
# 第1段階後: [12, 49, 10, 55, 100] (10以上)
# 第2段階後: [17, 54, 15, 60, 105] → 50以上: [54, 60, 105]
# 第3段階後: 平均は(54+60+105)=219/3=73, 73以上は[105]
# 出力: 105
```
私は処理ごとに変数を分けているのですが、上記のコードではnumsを使用し処理ごとに値を更新させています。
どちらも処理はうまくいきますが、可読性についてどちらが高いかわたしもChatgptも悩んでいたようなのでもしわかる方、上記よりも可読性が高いコードがあればコメントで教えていただけると幸いです

# まとめ
今回は繰り返しの問題を解いてみましたが、比較的うまくコードを書くことができました。しかし次回書く予定の問題は2回トライしてもうまくいかなかった問題でかなり苦労しました。演習についての記事をまだ上げますのでフィードバックよろしくお願いいたします。
