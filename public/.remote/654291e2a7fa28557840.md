---
title: 【React】React router クエリパラメータとstateの渡し方
tags:
  - 初心者
  - React
  - Router
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-15T12:08:11+09:00'
id: 654291e2a7fa28557840
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。

この講座の内容は非常にわかりやすいのですが、紹介されている React および React Router のバージョンがやや古く、現在主流となっている react-router-dom バージョン 7 とは操作方法が大きく異なります。

そこで本記事では、講座内で紹介されている内容をもとに、2025 年 5 月 10 日時点での react-router-dom の最新バージョン (7.5.3) に対応した クエリパラメータと state の渡し方について解説します。

## 開発環境

- React 19.1.0
- Vite 6.3.5
- react-router-dom 7.5.3

## 始める前に

最初に react-router-dom をインストールしましょう:

```bash
npm install react-router-dom
```

インストール後、`package.json` の `dependencies` に `react-router-dom@7.5.3` が含まれていることを確認してください。

## クエリパラメータとは？

クエリパラメータとは、URL の末尾に `?` をつけて付加できる情報のことです。たとえば、検索条件やフィルター条件など、画面の状態に応じた一時的なデータを URL に含めたい場合によく使われます。

例：

```
https://example.com/search?keyword=react&limit=10
```

この場合、`keyword` は `react`、`limit` は `10` という値が設定されています。

React Router を使うことで、これらのパラメータを簡単に取得して表示や処理に活かすことができます。

## 1. クエリパラメータの渡し方

React Router v7 では、URL にクエリパラメータを付与してデータを渡すことができます。
以下はその基本的な使い方です。

### 例：リンクにクエリを含める

```jsx
import { Link } from 'react-router-dom';

<Link to="/search?keyword=react&limit=10">検索</Link>;
```

### クエリの取得方法

クエリパラメータは `useLocation` フックと `URLSearchParams` を組み合わせて取得します。

```jsx
import { useLocation } from 'react-router-dom';

const SearchPage = () => {
  const { search } = useLocation();
  const query = new URLSearchParams(search);
  const keyword = query.get('keyword');
  const limit = query.get('limit');

  return (
    <div>
      <p>キーワード: {keyword}</p>
      <p>リミット: {limit}</p>
    </div>
  );
};
```

`useLocation` を使用することによって、search(クエリパラメータ)を受け取ることができます。
なお、クエリパラメータを使用する場合は`new URLSearchParams(search)`をセットで使用することが多いようです。

## 2. state の渡し方

React Router の `navigate` や `Link` コンポーネントでは、クエリとは別に `state` を使って値を渡すこともできます。state は URL に表示されず、履歴オブジェクト経由で渡されます。

### 例：Link コンポーネントで state を渡す

```jsx
import { Link } from 'react-router-dom';

<Link to="/detail" state={{ id: 123, name: 'React' }}>
  詳細ページへ
</Link>;
```

### 例：useNavigate で state を渡す

`useNavigate` については次の Link を使わないページ遷移の記事で説明しますが、`useNavigate` でも state を渡すことが可能です。

```jsx
import { useNavigate } from 'react-router-dom';

const Component = () => {
  const navigate = useNavigate();

  const handleClick = () => {
    navigate('/detail', { state: { id: 123, name: 'React' } });
  };

  return <button onClick={handleClick}>詳細へ</button>;
};
```

### state の受け取り

```jsx
import { useLocation } from 'react-router-dom';

const DetailPage = () => {
  const location = useLocation();
  const state = location.state;

  return (
    <div>
      <p>ID: {state?.id}</p>
      <p>Name: {state?.name}</p>
    </div>
  );
};
```

## 3. クエリと state の違い

| クエリパラメータ | state              |
| ---------------- | ------------------ |
| URL に表示される | 表示されない       |
| ブックマーク可能 | ブックマーク不可   |
| リロード時も保持 | リロードで失われる |
| SEO で使える     | 一時的なデータ向き |

## まとめ

- クエリパラメータは `useLocation().search` + `URLSearchParams` で取得
- state は `Link` や `navigate` に `state` オプションを渡して利用
- クエリは共有・永続向き、state は一時的なデータの受け渡し向き

React Router v7 は、以前のバージョンと比べてシンプルな設計になっており、状態管理や画面遷移がより直感的に行えるようになっています。
ぜひこの使い方をマスターして、柔軟なルーティングを実現してみてください。

# 参考文献

https://www.udemy.com/share/104d6k3@42e714cVu4rgVDHDJf-ktUgk7fTCTCZNgNYDjNAfj2ycTQZlC2z-9pgXx7KV8hvxwQ==/
