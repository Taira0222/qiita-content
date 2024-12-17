---
title: 【Ruby】今日書いたコードの振り返り(条件判断)#6
tags:
  - Ruby
  - If
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-12-17T13:39:42+09:00'
id: 76305ac66eb4a0cfffa7
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカに住みながら独学でソフトウェアエンジニアを目指しているものです。
今回は前回と同様、条件判断に関するコードを解いたので、それについての学びをシェアしたいと思います。
普段は1時間ほどかけて問題を解くのですが、今回、最初の30分でかなり詰まってしまい、コードの実装は途中までしかできませんでした。
このブログでは、私が間違えた点や学び直したことを振り返り、より良いコードにするための改善策を紹介します。

## 問題の内容
オンラインショッピングサイトで商品を管理する在庫システムを作成してください。
商品には在庫数があり、注文やキャンセルによって在庫が変動するという問題です

### 要件
1. 商品には以下の情報があります：
* 商品名
* 価格
* 在庫数
* ステータス（"在庫あり"、"在庫切れ"、"入荷待ち"）
2. 以下の操作を実装してください：
* 注文: 在庫がある場合のみ注文が可能。注文時に在庫数が減少し、在庫が0になるとステータスが「在庫切れ」になります。
* キャンセル: 注文をキャンセルすると在庫が戻り、ステータスが「在庫あり」に戻ります。ただし、部分的なキャンセル(3個頼んで1個だけキャンセル)はできません
* 在庫補充: 商品の在庫を補充できます。在庫数が一定数以上になるとステータスが「在庫あり」になります。
3. 注文履歴を管理し、注文ごとの状態を確認できるようにしてください。
4. 状態の遷移は以下の通りです：
* 「在庫あり」→「在庫切れ」（在庫が0になった場合）
* 「在庫切れ」→「入荷待ち」（補充待ちの状態）
### クラス設計
* Productクラス: 商品情報と在庫状態を管理。
* Orderクラス: 注文情報を管理。
* Inventoryクラス: 在庫全体を管理し、注文や在庫補充を調整。

## 私のコード
```ruby
class Product
    attr_accessor :name, :price, :count, :status

    def initialize(name,price,count)
        @name = name 
        @price = price
        @count = count
        @status = "在庫あり" 
    end
end

class Order
    def initialize
        @orders = {}
    end

    def place_order(product,count)
        @orders[product] = count # @orderのハッシュにオーダーされた内容を入れる
    end

    def list_order
        puts "----------オーダー 一覧です--------------------------"
        @orders.each {|product,count| puts "商品名#{product}: #{count}個 注文されました" }
    end
end

class Inventory
    attr_accessor :inventorys
    def initialize
        @inventorys = []
    end

    def add_product(product)
        inventorys << product # セッターinbentorysを呼び出して、productを配列@inbectorysに代入
    end

    def place_order(product,count)
        same_product = @inventorys.find {|i| i == product} # @inventorys配列の中のproductと一致するモノを探す
        if same_product.count < count
            puts "注文数よりも在庫数が少ないため注文することができません"
        else
            puts "注文を受け付けました。商品名:#{product} 注文数: #{count}"
            same_product.count -= count
            Order.place_order(product,count) #Orderクラスにproductとorderされたcountを入れる
        end
    end
end

    # cancel_order, restock_product,list_products は30分では書けませんでした
```
## コードの改善点
1. Productクラスにupdate_statusメソッドがないこと
商品の在庫数が変動したときに、update_statusメソッドでステータスを更新する必要がありました。
私の実装では、ステータスの更新をInventoryクラスに書こうとしていましたが、本来はProductクラスにそのメソッドを追加する必要がありました。
2. Orderクラス: 注文情報を管理という文章を言葉通りに受け取ってしまった
問題文に「注文情報を管理」とありましたが、私はハッシュや配列で注文を管理することに固執してしまいました。
本来は、注文ごとにOrderクラスをインスタンス化し、必要な情報をOrderオブジェクトとして管理するべきでした。
3. インスタンスメソッドとして定義しているメソッドを、クラスメソッドのように呼び出してしまった
Inventoryクラスのplace_orderメソッド内に書いたOrder.place_order(product,count)について、Orderクラス内で self.list_orderと定義しておく必要がありました。(そもそも論理が間違っていますが、、、)


## 模範解答
```ruby
class Product
    attr_accessor :name, :price, :stock, :status

    def initialize(name,price,stock)
        @name = name 
        @price = price
        @stock = stock
        @status = stock > 0 ? "在庫あり" : "在庫切れ"
    end

    def update_status
        if @stock == 0
            @status = "在庫切れ"
        elsif @stock > 0
            @status = "在庫あり"
        end
    end
end


class Order
    attr_reader :product, :count

    def initialize(product,count)
        @product = product
        @count = count
    end
end

class Inventory
    def initialize
        @products = []
        @orders = []
    end

    def add_product(product)
        @products << product
    end

    def place_order(product, count)
    if product.stock >= count
      product.stock -= count
      product.update_status
      @orders << Order.new(product, count)
      puts "注文成功: 商品名: #{product.name}, 数量: #{count}"
    else
      puts "注文失敗: 商品名: #{product.name}, 在庫不足"
    end
  end

  def cancel_order(product, count)
    order = @orders.find { |o| o.product == product && o.count == count }
    if order
      product.stock += count
      product.update_status
      @orders.delete(order)
      puts "キャンセル成功: 商品名: #{product.name}, 数量: #{count}"
    else
      puts "キャンセル失敗: 該当する注文が見つかりません。商品名と注文した個数を再度ご確認ください"
    end
  end

  def restock_product(product, count)
    product.stock += count
    product.update_status
    puts "補充成功: 商品名: #{product.name}, 数量: #{count}"
  end

  def list_products
    puts "----------在庫一覧です--------------------------"
    @products.each do |product|
      puts "商品名: #{product.name}, 価格: #{product.price}円, 在庫数: #{product.stock}, ステータス: #{product.status}"
    end
  end
end

product1 = Product.new("ノートPC", 1000, 5)
product2 = Product.new("スマートフォン", 700, 0)

inventory = Inventory.new
inventory.add_product(product1)
inventory.add_product(product2)

inventory.place_order(product1, 2)   # 注文成功
inventory.place_order(product2, 1)   # 注文失敗（在庫切れ）

inventory.cancel_order(product1, 2)  # キャンセル成功
inventory.restock_product(product2, 5)  # 補充成功

inventory.list_products

```

出力例
```ruby
注文成功: 商品名: ノートPC, 数量: 2
注文失敗: 商品名: スマートフォン, 在庫不足
キャンセル成功: 商品名: ノートPC, 在庫: 2
補充成功: 商品名: スマートフォン, 数量: 5
----------在庫一覧です--------------------------
商品名: ノートPC, 価格: 1000円, 在庫数: 5, ステータス: 在庫あり
商品名: スマートフォン, 価格: 700円, 在庫数: 5, ステータス: 在庫あり
```

## 模範解答の解説
* Productクラスのupdate_statusメソッドについて
商品の在庫数が変更された際に、ステータスを適切に更新するためにupdate_statusメソッドを作成しました。これにより、在庫が0になったときに自動で「在庫切れ」に変更されます。
* Orderクラスについて
Orderクラスは、個別の注文に関する情報を保持するインスタンスとして使用しています。これにより、複数の注文を管理することができます。
* Inventoryクラスでの注文処理
Inventoryクラスでは、place_orderメソッドで注文を受け付け、注文の際に在庫が足りない場合にはエラーメッセージを表示します。また、注文をキャンセルするためのcancel_orderメソッドも追加しました。

## 学んだこと
* クラス設計をしっかり理解して、それ通りに設計する
考えてほかのクラスに入れてしまった方がいいかなと考える時もありますが、まずはその考えを捨てて指示されたクラス設計をする必要があると思いました
* 難しい問題は一回だけでなく何回も解いて自分の力に変える
前回と今回の問題は自分にとってかなり難しい問題でした。今の時点でできるまともな分析は1つだけということからもわかるくらいぼこぼこにやられました。
これはプログラミングだけでなく、困難に背を向けずストレス値を無理ない程度に継続していればいつかは当たり前になると思います。今回も解けなかったり、理解度が少なかったとしてもめげずに再度問題を解いてみようと思いました

## まとめ
条件判断についての記事を書いてみました。わたしにとっては前回同様かなり難しく感じました。
今回のコードの設計思想について何かしらの手がかりやヒントが思いついてシェアしていただける方はどうぞコメントいただけるとありがたいです。
