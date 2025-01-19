---
title: 【Ruby】今日書いたコードの振り返り(module)#12
tags:
  - Ruby
  - 初心者
  - module
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-13T15:25:54+09:00'
id: 4a7113361efc18d910e0
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指しているものです。
本日は Ruby の module を使った問題について学んだ内容を共有したいと思います。

# 問題内容
あなたは、データ処理パイプラインを構築するシステムを作成します。
入力となる配列データに対し、複数の処理ステップ（フィルタリング、変換、集計など）をモジュールとして定義し、パイプラインクラスに動的にミックスインすることで、処理内容をカスタマイズできる仕組みを作ってください。

## 要件
1. DataPipelineクラス：
    * @dataインスタンス変数に配列データを保持します。
    * processメソッドを呼び出すと、ミックスインされたモジュールが順番にデータを処理し、最終結果を返す。
    * ミックスインするモジュールは任意の数だけ追加可能で、追加した順序で処理を適用。
2. モジュールの例：
    * FilterModule：@dataから特定条件で要素を除外する
    * TransformModule：@dataの各要素に対して特定の変換を施す（例: 全てに+10）
    * AggregateModule：最後に@dataの合計や平均などの集計結果を返す代わりに、@dataを集計後の1要素に置き換える
3. 実行例：
    * FilterModuleモジュールによって10以上の要素のみ残す
    * TransformModuleモジュールによって残った要素に+5する
    * AggregateModuleモジュールによって最終的に平均値を1要素の配列にする
    * DataPipelineインスタンスに [3,12,49,10,55,7,100] を渡し、processを実行すると、
        * 第1ステップ(フィルタ): [12,49,10,55,100]
        * 第2ステップ(変換): [17,54,15,60,105]
        * 第3ステップ(集計): すべての要素の平均（(17+54+15+60+105)=251/5=50.2切り捨て50）を [50] として返す
    * 最終出力: [50]
## 出力例
```ruby

pipeline = DataPipeline.new([3,12,49,10,55,7,100])

pipeline.extend(AggregateModule)
pipeline.extend(TransformModule)
pipeline.extend(FilterModule)

p pipeline.process
# => [50]
```

# 私の解答
最初に書いたコードは以下の通りです。なお、以下のコードでは正常に動かないので、ご了承ください
```ruby
module FilterModule
    def process
        @arr.select!{|x| x >= 10}
    end
end

module TransformModule
    def process
        @arr.map!{|x| x + 5}
    end
end

module AggregateModule
    def process
        @arr.sum.fdiv(@arr.size).round(half: :down)
    end

end

class DataPipeline
    def initialize(arr)
        @arr = arr
    end

    def process
        @arr
    end
end

pipeline = DataPipeline.new([3,12,49,10,55,7,100])


pipeline.extend(AggregateModule)
pipeline.extend(TransformModule)
pipeline.extend(FilterModule)


p pipeline.process
# =>[12, 49, 10, 55, 100]
```

最初この問題を取り組んだときは、`extend` や特異クラスを使ったミックスインの仕組み、そして `super` の必要性をうまく理解できていませんでした。
関連記事として、以下に参考リンクを載せているので、興味があればご覧ください。

https://qiita.com/Taira0222/items/108b8ecc0a42ebca3ed1

上記のコードの問題点は主に2つあります
1. 継承チェーンについて把握できていない
`extend` は 特異クラス（`singleton class`）にモジュールを取り込みます。すると、メソッド探索順序は以下のようになり、最後に `extend` したモジュールが呼び出しの先頭になります。
```ruby
pipeline.singleton_class.ancestors
#=> [#<Class:#<DataPipeline:0x000002113912c900>>, FilterModule, TransformModule, AggregateModule, DataPipeline, Object, Kernel, BasicObject]
```
その結果、呼ばれる `process` は `FilterModule` → `TransformModule` → `AggregateModule` の順となります。
2. superを使用できていない
`super` がないと、先頭にあるモジュールの `process` メソッドで処理が完結してしまい、後続のモジュールのメソッドが呼ばれません。。

## 解答例
これはChatGPTが作成した解答例です。
```ruby
module FilterModule
    def process
        @arr.select!{|i|i >= 10}
        super
    end

end

module TransformModule
    def process
        @arr.map!{|i|i + 5}
        super
    end
end

module AggregateModule
    def process
        arr_sum = @arr.sum
        arr_calc = arr_sum.fdiv(@arr.size).round(half: :down)
        @arr = arr_calc
        super
    end
end

class DataPipeline
    def initialize(arr)
        @arr = arr
    end
    def process
        @arr
    end
end

# パイプラインにモジュールをミックスインする
pipeline = DataPipeline.new([3,12,49,10,55,7,100])
# 順番にexpandすることで処理順を決定
pipeline.extend(AggregateModule)
pipeline.extend(TransformModule)
pipeline.extend(FilterModule)
p pipeline.process
# => [50]
```
`super`を使うことで、下記のようにメソッドが順番に呼ばれるイメージです
```ruby
p pipeline.process

# processメソッドが呼び出された後
def process
        @arr.select!{|i|i >= 10} #FilterModuleモジュールのprocessが呼び出される
        @arr.map!{|i|i + 5} # superによってTransformModuleモジュールのprocessが呼び出される
        arr_sum = @arr.sum　# superによってAggregateModuleモジュールのprocessが呼び出される
        arr_calc = arr_sum.fdiv(@arr.size).round(half: :down)
        @arr = arr_calc
        @arr　# superによってDataPipelineのprocessが呼び出される
    end
```
なぜこの順番になるかは、`singleton_class.ancestors` を見ればわかります。
モジュールを `extend` していくたびに、そのモジュールが呼び出しチェーンの先頭へ追加されます。最後に追加したモジュールが最初に呼び出され、そこから `super` で次のモジュールへ処理が渡っていくわけです。

# まとめ
今回は `Ruby` の `module` を使ったデータ処理パイプラインの仕組みを取り上げました。
最初は `extend` を使ったミックスインや特異クラスの呼び出し順序、そして `super` が必要な理由などがなかなか理解できませんでしたが、改めて学習し直してコードを整理することで、ようやく仕組みを把握できるようになりました。
次回も引き続き `module` に関する問題を扱う予定です。ぜひご覧ください！
