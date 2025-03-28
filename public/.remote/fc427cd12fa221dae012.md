---
title: 【SQL】内部結合と外部結合
tags:
  - SQL
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-28T11:58:49+09:00'
id: fc427cd12fa221dae012
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカに住みながら独学でエンジニアを目指しているTairaです。

SQL において、テーブル同士を結合（JOIN）するときには、大きく分けて **内部結合（INNER JOIN）** と **外部結合（OUTER JOIN）** があります。
本日はそれぞれの特徴を解説します。

## 1. 内部結合（INNER JOIN）

### 概要

2 つのテーブル間で結合条件（主に `ON` 句に記述）を満たす行同士のみを取り出す結合です。たとえば、 `TableA` と `TableB` を内部結合するときには、両方のテーブルで結合キーが一致するデータのみが結果に含まれます。それ以外の行は取り除かれます。

### イメージ

「両テーブルで **共通している** 部分だけを取り出す」イメージです。ベン図でいうと、2 つの円が重なり合っている **交差** 部分だけを取り出す感じになります。

---
## 2. 外部結合（OUTER JOIN）

外部結合は、内部結合と違って「**結合条件に合わない行も取り出す**」ことができる結合方法です。大きく分けて **左外部結合（LEFT OUTER JOIN）** 、 **右外部結合（RIGHT OUTER JOIN）** 、**完全外部結合（FULL OUTER JOIN）** の 3 種類があります。

### 2-1. 左外部結合（LEFT OUTER JOIN）

#### 概要

左外部結合では、 SQL 文で指定した“左”側のテーブル（ `FROM` の後に最初に書くテーブル）の全行を必ず結果として含めます。そのうえで、左側のテーブルと右側のテーブルを比較した際、結合条件を満たす行が右側テーブルにあればそれらが結合されます。もし右側テーブルに該当する行が見つからなければ、その部分は `NULL` として結果に残ります。

```sql
SELECT ...
FROM TableA
LEFT JOIN TableB
    ON TableA.key = TableB.key;
```

#### イメージ

ベン図でいうと、左の円（左側テーブル）全体 + 右の円との交差部分が結果に含まれる状態です。右の円に該当するものがなければ、右側のカラムが `NULL` になります。

### 2-2. 右外部結合（RIGHT OUTER JOIN）

#### 概要

右外部結合では、上記の「左外部結合」の逆で、“右”側に書かれたテーブルの全行を必ず含めます。右側に対応行がない場合は `NULL` となります。

```sql
SELECT ...
FROM TableA
RIGHT JOIN TableB
    ON TableA.key = TableB.key;
```

#### なぜあまり使われないのか

実際の現場では、右外部結合（RIGHT OUTER JOIN）はあまり使われないことが多いです。なぜなら、 `TableA` と `TableB` の位置を入れ替えて LEFT JOIN に書き換えたほうが分かりやすい場合が多いからです。たとえば:

```sql
-- 右外部結合
FROM TableA
RIGHT JOIN TableB ON TableA.key = TableB.key;

-- これと等価な左外部結合
FROM TableB
LEFT JOIN TableA ON TableB.key = TableA.key;
```

### 2-3. 完全外部結合（FULL OUTER JOIN）

#### 概要

左側テーブルと右側テーブルの両方の全行を取り出す結合です。結合条件を満たさない部分は `NULL` を含む行として結果に残ります。ただし、一部の RDBMS（MySQL など）では FULL OUTER JOIN がサポートされていない場合があります。

---
## 3. LEFT JOIN と RIGHT JOIN の具体例

ここでは 2 つのテーブル **Students（生徒情報）** と **Grades（成績情報）** を用いた具体例を示します。

### テーブル構造とデータ

#### Students テーブル

| id | name    |
|----|---------|
| 1  | Alice   |
| 2  | Bob     |
| 3  | Charlie |

#### Grades テーブル

| student_id | grade |
|------------|-------|
| 2          | 90    |
| 3          | 80    |
| 4          | 95    |

- `Students` には `id` が 1～3 のデータ
- `Grades` には `student_id` が 2, 3, 4 のデータ
  - `student_id=4` は `Students` に該当する生徒がいない
  - `id=1` (Alice) に対応する成績がない

### LEFT OUTER JOIN の例

```sql
SELECT
    S.id AS student_id,
    S.name,
    G.grade
FROM
    Students AS S
LEFT JOIN
    Grades AS G
    ON S.id = G.student_id;
```

#### 実行結果イメージ

| student_id | name     | grade |
|------------|----------|-------|
| 1          | Alice    | NULL  |
| 2          | Bob      | 90    |
| 3          | Charlie  | 80    |

- **左側**テーブル（Students）の全行が必ず返ってきます。
- Alice (id=1) は `Grades` にデータがないため `grade` が `NULL` です。
- `Grades` テーブルの `student_id=4` は `Students` テーブルに対応がなく除外されます。

### RIGHT OUTER JOIN の例

```sql
SELECT
    G.student_id,
    G.grade,
    S.name
FROM
    Students AS S
RIGHT JOIN
    Grades AS G
    ON S.id = G.student_id;
```

#### 実行結果イメージ

| student_id | grade | name     |
|------------|-------|----------|
| 2          | 90    | Bob      |
| 3          | 80    | Charlie  |
| 4          | 95    | NULL     |

- **右側**テーブル（Grades）の全行が必ず返ってきます。
- `student_id=4` には `Students` に該当がなく、 `name` が `NULL` です。
- `Students` テーブルにいる Alice (id=1) は結果に含まれません。

---
## 4. まとめ

1. **内部結合（INNER JOIN）**
   - 結合条件が合致する行だけを取得する。
   - 両テーブルに共通で存在するデータのみが結果に残る。
2. **外部結合（OUTER JOIN）**
   - 結合条件に合致しない行も含める結合方法。
   - **LEFT OUTER JOIN**: 左側テーブルの全行を返す。対応なしは `NULL` になる。
   - **RIGHT OUTER JOIN**: 右側テーブルの全行を返す。対応なしは `NULL` になる。
   - **FULL OUTER JOIN**: 両方のテーブルの全行を返す。対応なしは `NULL` になる。



