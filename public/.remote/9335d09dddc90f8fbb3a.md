---
title: 【アルゴリズム】二分探索
tags:
  - アルゴリズム
  - 初心者
  - 未経験エンジニア
  - 二分探索
  - 独学
private: false
updated_at: '2025-04-03T11:57:48+09:00'
id: 9335d09dddc90f8fbb3a
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカに住みながら独学でエンジニアを目指しているTairaです。
現在、Leetcodeでコーディング面接対策を始める前に重要そうなアルゴリズムをピックアップして勉強しています。
本日は二分探索についての記事を書こうと思います。アルゴリズムの中でも一番有名なのでは？と思うので同じくアルゴリズムを勉強している人は参考にしてもらえれば幸いです


## 二分探索とは？

二分探索（Binary Search）は、**ソートされた配列**の中から目的の要素を効率よく探すアルゴリズムです。
探索範囲を半分に絞りながら中央の要素とターゲットを比較し、一致すればそのインデックスを返します。
一致しない場合は、ターゲットの大小に応じて左半分または右半分に探索範囲を絞って再度検索を行います。

線形探索に比べて比較回数が大幅に少なく、高速に処理できます。

---

## 特徴
- **時間計算量**: O(log n)で処理スピードがとても速い
- **空間計算量**: O(1)（反復的な実装の場合）でメモリ消費量が少ない
- **前提条件**: 配列が昇順または降順にソートされている必要があり、すべてにあてはめることはできない。

---

## 基本問題：二分探索

### 問題:
ソートされた整数配列 `nums` と整数 `target` が与えられたとき、`target` が存在するならそのインデックスを返し、存在しない場合は `-1` を返してください。

### 例:
```python
入力: nums = [-1, 0, 3, 5, 9, 12], target = 9
出力: 4
```

### Python解法:
```python
def binary_search(nums, target):
    left, right = 0, len(nums) - 1

    while left <= right:
        mid = left + (right - left) // 2　# JavaやC,C++ 等の言語の固定サイズの整数(32bit)を使っている言語のオーバーフロー対策
                                          # Pythonなら mid = (left + right ) // 2でも問題ない
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return -1
```

---

## 類題

### 1. 挿入位置を検索する
**問題**: 目的の値を配列内に挿入するとき、ソート順を保つように挿入すべきインデックスを返してください。

```python
def search_insert_position(nums, target):
    left, right = 0, len(nums) - 1

    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return left
```

### 2. 数当てゲーム（Higher or Lower）
**問題**: `guess(num)` 関数を使って、できるだけ少ない回数で正解の数を当ててください。

```python
# デモ用の guess 関数（仮の正解を設定）
guess_number = 6

def guess(num):
    if num > guess_number:
        return -1
    elif num < guess_number:
        return 1
    else:
        return 0

def guessNumber(n):
    left, right = 1, n

    while left <= right:
        mid = (left + right) // 2
        result = guess(mid)

        if result == 0:
            return mid
        elif result == -1:
            right = mid - 1
        else:
            left = mid + 1

    return -1
```

### 学習方法
私は「アルゴリズム図鑑」というアプリで動きを確認した後、ChatGPTに問題を生成してもらい、概念をつかみながらコードを学習しています。
合わせてYoutubeで binary search algorithm pythonと調べて、二分探索の動きとコードの説明を聞きながら理解度を上げました。

https://youtu.be/DnvWAd-RGhk?si=7Qlst1eyvB4ruMtv

上記の動画は結構わかりやすいので、よかったら見てみてください。
海外はソフトウェアエンジニアになるために、コーディング面接が必須ということもあり日本と比べてアルゴリズムの解説動画がかなり豊富なので日本語検索よりも英語検索をおすすめします。

---

## まとめ
二分探索は、最も基本かつ強力な探索アルゴリズムのひとつです。
基本パターンを理解しておくことで、単なる数値探索だけでなく、挿入位置の探索や不明な値の推測など、さまざまな応用問題に対応できるようになります。



