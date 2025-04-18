---
title: 【SQL】トランザクションの分離レベル
tags:
  - Network
  - 初心者
  - 未経験エンジニア
  - 独学
  - ファントムリード
private: false
updated_at: '2025-04-18T11:58:41+09:00'
id: aa2a899625c2b09baa13
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに

こんにちは。アメリカに住みながら、独学でエンジニアを目指しているTairaです。
前回の3つの記事ではトランザクションを採用するにあたっての3つの副作用について説明しましたが、本日はトランザクションの分離レベルについて解説していきます

## トランザクションの分離レベル

SQLにおける分離レベルは、複数のトランザクションが同時にデータへアクセスする際に、どれだけ分離されてるかを指定するものです。
分離レベルの違いは、下記のような副作用を防ぐ度合によって表れます。

- ダーティーリード (Dirty Read)
- 非繁リード (Non-repeatable Read)
- ファントムリード (Phantom Read)


## 1. READ UNCOMMITTED

- **防げる副作用**: なし
- **特徴**: 他トランザクションが書き込んだ未コミットのデータも読める
- **ロック**: 読み取り時の共有ロックを一切取得しない

### Dirty Readはなぜ起きるのか

Dirty Readは、あるトランザクションAが書き込んだ未コミット状態のデータを、別のトランザクションBが読み込めてしまうことにより発生します。

### READ UNCOMMITTEDの場合

READ UNCOMMITTEDは、データの読み取り時に共有ロックを一切取得しません。そのため、他のトランザクションが書き込み中のデータも読み取れてしまいます。

```sql
-- トランザクションA (UPDATE中, 未コミット)
UPDATE users SET name='Alice' WHERE id=1;

-- トランザクションB (READ UNCOMMITTED)
SELECT * FROM users WHERE id=1;
-- => 'Alice' (未コミットの値を読めてしまう)
```

### READ COMMITTED以降ではなぜ防げるのか

READ COMMITTED以上のレベルになると、DBMSは未コミットのデータにはアクセスできないように制御します。多くのシステムは、書き込み中の行に対しては読み取りを一時的に待機させ、Dirty Readを防こうとします。

```sql
-- トランザクションA (UPDATE中)
UPDATE users SET name='Alice' WHERE id=1;

-- トランザクションB (READ COMMITTED)
SELECT * FROM users WHERE id=1;
-- => コミット後まで待機
```

## 2. READ COMMITTED

- **防げる副作用**: Dirty Read
- **特徴**: 読み取りのたびに最新のコミット済データを読む
- **ロック**: 読み時に一瞬だけ共有ロックを取得し、読み終了後に解除

### READ COMMITTEDでNon-repeatable Readが起きる理由

Non-repeatable Readは、同じトランザクション内で同じ行を複数回読んだとき、その間に他トランザクションによって値が変更されてしまい、結果が異なる現象です。

READ COMMITTEDは、読み時に一瞬だけ共有ロックを取得し、すぐ解除します。そのため、再度読み込むことで変更後の値を読む可能性があります。

```sql
-- トランザクションA
BEGIN;
SELECT name FROM users WHERE id=1; -- "Alice"

-- この間にトランザクションB
UPDATE users SET name='Bob' WHERE id=1;

-- Aが再度読み込み
SELECT name FROM users WHERE id=1; -- "Bob"
COMMIT;
```

## 3. REPEATABLE READ

- **防げる副作用**: Dirty Read, Non-repeatable Read
- **特徴**: トランザクション開始時のスナップショットを読む (MVCC)
- **ロック**: 書き込み対象行には排他ロックを取得する

### REPEATABLE READのスナップショット挙動

REPEATABLE READは、トランザクション開始時のデータの状態(スナップショット)を保持して、同じデータを何度読んでも結果が同じになるよう保証します。

これはMVCC(Multi-Version Concurrency Control)という技術を使って実現されています。

| Isolation Level | ロック方式           | 読み取りの仕組み         |
| --------------- | --------------- | ---------------- |
| READ COMMITTED  | 一瞬の共有ロック        | スナップショット不使用      |
| REPEATABLE READ | MVCC (ロックを最小限に) | 開始時点のスナップショットを使用 |

```sql
-- トランザクションA (REPEATABLE READ)
BEGIN;
SELECT name FROM users WHERE id=1; -- "Alice"

-- この間にBが書き換え
UPDATE users SET name='Bob' WHERE id=1;

-- Aが再度読み込み
SELECT name FROM users WHERE id=1; -- "Alice" (スナップショット読み)
COMMIT;
```

## 4. SERIALIZABLE

- **防げる副作用**: Dirty Read, Non-repeatable Read, Phantom Read
- **特徴**: すべてのトランザクションを一つずつ実行するように振る舞う
- **ロック**: 行に加え、範囲に対してもギャップロックを取得

### SERIALIZABLEはなぜ最も厳格か

SERIALIZABLEはPhantom Readをも防ぐため、行のロックだけではなく、枠となる値範囲に対してもギャップロック(範囲ロック)を取得します。

```sql
-- SERIALIZABLEトランザクション
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM accounts WHERE balance BETWEEN 1000 AND 2000;
-- => この範囲に対してギャップロック

-- 他トランザクションからの追加
INSERT INTO accounts(balance) VALUES(1500);
-- => 範囲ロックによりブロック
COMMIT;
```


## 各レベルの比較表

| Isolation Level  | Dirty Read | Non-repeatable Read | Phantom Read | 読み時ロック       | 書き時ロック |
| ---------------- | ---------- | ------------------- | ------------ | ------------ | ------ |
| READ UNCOMMITTED | 起きる        | 起きる                 | 起きる          | なし           | 行単位    |
| READ COMMITTED   | 防げる        | 起きる                 | 起きる          | 一瞬だけ         | 行単位    |
| REPEATABLE READ  | 防げる        | 防げる                 | DBMS次第    | MVCC (ロック不要) | 行単位    |
| SERIALIZABLE     | 防げる        | 防げる                 | 防げる          | 行 + 範囲       | 行 + 範囲 |


## まとめ

- Dirty ReadはREAD UNCOMMITTEDで起きるが、READ COMMITTED以降で防げる
- Non-repeatable ReadはREAD COMMITTEDで起きうるが、REPEATABLE READで防げる
- REPEATABLE READはMVCCを使ってロックを取らずに一貫性を保証
- SERIALIZABLEは行に加え範囲もロックするため、最も厳格な分離性を保証
- DBMSの実装により動作は異なる場合もあるため、実際の挙動を確認することも大切

