---
title: 【Ruby】今日書いたコードの振り返り(繰り返し)#10
tags:
  - Ruby
  - 初心者
  - return
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-28T11:21:15+09:00'
id: 917655139343823afebd
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指しているものです。
今回も繰り返しの問題を扱っていこうと思います。

## 問題内容
配列に整数と文字列が混在しています。以下のルールで要素を変換し、すべての要素が文字列 "fix" になったらループ処理を終了します。なお、無限ループ対策として文字列に末尾で ? を付与しすぎることを防ぐ追加ルールを導入します。

## 要件
1. 配列内には整数と文字列が混ざっています。

* 整数の場合：
    * 10未満なら、その整数に+10して再度次ループで判定
    * 10以上50未満なら、その整数を文字列に変換し、末尾に"ok"を付けて文字列化
    * 50以上なら、その整数は "fix" という文字列に変換
* 文字列の場合：
    * 文字列が"fix"のときはそのまま放置
    * "ok"で終わる文字列は、その数だけ再度整数化して+5する
    * （例："15ok" → 整数15に戻し+5=20として次のループで整数20として判定）
    * 上記いずれでもない文字列は以下のルールで処理
        1. 長さが10文字以上 なら 最後の3文字 を除去して短くする
        2. 長さが10文字未満 なら末尾に "?" を付ける
        3. ただし、末尾に ? が5つ以上連続して付与されている場合 は、強制的に "fix" として扱い、ループを終了させる
            * 例: "hello?????" → "fix" として確定し、それ以上処理しない
* 上記の場合以外
  * 配列やハッシュなどの整数,文字列に該当しないものが来た場合はfix とする

2. この処理を各要素に対して実行し、全ての要素が文字列"fix"となったらループ終了。

3. 最終的に全てが"fix"になった配列を出力する。

## 私のコード
以下のコードは私が最初に書いたコードですがまともに動かないのでご了承ください
```ruby
def process_until_fix(data)
    data.map do |item|
        # 整数の処理
        if item.class == "integer"
            if item < 10
                item += 10
                process_until_fix(item)
            elsif item >=10 && item < 50
                item = item_to.s + "ok"
                process_until_fix(item)
            elsif item >= 50
                item = "fix"
            end
        end # ここで一時終了しておかないと再帰呼び出しが下の文字列の式に反映されない

        if item.class == "string"
            if item == "fix"
                return item
            elsif item.slice(-2,2) == "ok"
                item = item.slice!(0,2).to_i + 5
                process_until_fix(item)
            else
                unless item.slice(-5,5) == "?????"
                    if item.size >= 10
                        item = item.slice!(0,(item.size - 3))
                        process_until_fix(item)
                    else
                        item = item.to_s + "?"
                        process_until_fix(item)
                    end
                else
                    item = "fix"
                    return item
                end
            end
        end
    end     
end


data = [3, 12, 49, "hello", 55, "99ok"]
# 処理の流れを簡略: 
#  - 3は10未満→3+10=13 →文字列化"13ok"に次のループで
#  - "hello"は5文字未満→"hello?"追加...など状態が複雑に変化
result = process_until_fix(data)
p result
# 最終的には全て"fix"になって終了
```

### 上記のコードの振り返り
1. 早期returnの挙動を理解していませんでした。
通常のif文の場合はreturn を使う必要がないことを認識していませんでした

2. ロジックが別なものを1つのメソッドで行おうとした
これは以前もやってしまったのですが、クラス内でないとメソッドをわけるという発想にならず1つにまとめられませんでした。
本来は以下のメソッドが必要でした
* 計算をする(整数or文字列の処理)
* すべてfixになったかの確認をする
* 上記2つをまとめて処理する

3. 判定の書き方等のrubyの文法を正しく使えなかった
    * `item.class =="integer"`
    この書き方では、サブクラスや互換性のあるオブジェクトを無視することになります。また、Rubyのダックタイピング(そのオブジェクトが何のクラスかよりもどうふるまうか)の原則を無視してしまうのでitem.is_a?(Integer)のほうが適切
    * item ="fix"のように書く必要がなかった
    if文の最後の式を返り値として返すので、単純に "fix" だけでよく冗長であった

### 上記を踏まえたコード
```ruby
# 処理を3つに分ける
# 1 すべてfixか確認する
# 2 process_elementで整数と文字列の処理を行う
# 3 1,2の処理を process_until_fixで行う(再帰呼び出しするため)

def arr_fix?(arr)
    arr.all?{|x| x == "fix"}
end

def process_element(elem)
    # 整数の処理
    if elem.is_a?(Integer) # クラスの判定。rubyらしいダックタイピングの観念のもと elem.class ではなくelem.is_a?にしている
        if elem < 10
            elem + 10 
        elsif elem >= 10 && elem < 50
            elem.to_s + "ok"
        else
            "fix"
        end
    # 文字列の処理
    elsif elem.is_a?(String) #fixの処理
        if elem == "fix"
            "fix"
        elsif elem.end_with?("ok") 
            num_str = elem.gsub(/ok$/,"")
            num = num_str.to_i
            num + 5
        else
            if elem[-5..-1] == "?????"
                "fix"
            elsif elem.size >= 10
                elem[0...(elem.size - 3)] 
            elsif elem.size < 10
                elem + "?"
            end
        end
    end
end


def process_until_fix(arr)
    until arr_fix?(arr)
        arr.map! do |elem|
            unless elem.is_a?(Integer) || elem.is_a?(String)
                "fix"
            else
                elem == "fix"? "fix" : process_element(elem)
            end
        end
    end
    arr 
end

data = [3, 12, 49, "hello", 55, "99ok",[1,2,3]]
# 処理の流れを簡略: 
#  - 3は10未満→3+10=13 →文字列化"13ok"に次のループで
#  - "hello"は5文字未満→"hello?"追加...など状態が複雑に変化
result = process_until_fix(data)
p result
# 最終的には全て"fix"になって終了
```

上記のコードあれば、おそらく["fix", "fix", "fix", "fix", "fix", "fix", "fix"]となり要件は満たしているはずです。


## 学んだこと
1. クラスを比較する際には`is_a?`メソッドを使うのが好ましい
これはchatgptからの情報ですが、`item.class == Integer`だとitemのクラスだけしかわからず、本来の動きとしてはその上に継承しているクラスについても考慮する必要があります。(ダックタイピング)

```ruby
class MyArray < Array; end

a = MyArray.new([1, 2, 3])

if a.class == Array
  puts "This is an Array"
else
  puts "Not an Array"
end
# => "Not an Array"

p a.class
# => "MyArray"
```
上記の例は配列ですが、MyArrayも配列として処理したいですが、classメソッドではインスタンスaのクラス名までしかわからず思った仕様になりません。

2. returnについて
これは上記でも少し触れましたが、違う観点で学んだことを載せておきます
例えば以下のコードの場合
```ruby
def process_until_fix(arr)
    until arr_fix?(arr)
        arr.map! do |elem|
            return "fix" unless elem.is_a?(Integer) || elem.is_a?(String)
            elem == "fix"? "fix" : process_element(elem)
        end
    end
    arr 
end
```
returnをしたらブロックの処理だけでなく、process_until_fixメソッドの処理を終わらせてしまうので
```ruby
def process_until_fix(arr)
    until arr_fix?(arr)
        arr.map! do |elem|
            unless elem.is_a?(Integer) || elem.is_a?(String)
                "fix"
            else
                elem == "fix"? "fix" : process_element(elem)
            end
        end
    end
    arr 
end
```
と書くのがようです。


# まとめ
わたしにとってはかなり難しく感じ、検討しましたがchatgptに点数をつけてもらったら上記のコードで90点でした。
もっと効率的な書き方や、コードは動いてるけど根本的に間違っていることがあればフィードバックいただけるとうれしいです。
