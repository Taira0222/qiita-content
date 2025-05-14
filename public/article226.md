---
title: 【React】React router URLパラメータ
tags:
  - 初心者
  - React
  - Router
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-14T12:08:29+09:00'
id: ca92af9cadb85432228d
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。

この講座の内容は非常にわかりやすいのですが、紹介されている React および React Router のバージョンがやや古く、現在主流となっている react-router-dom バージョン 7 とは操作方法が大きく異なります。

そこで本記事では、講座内で紹介されている内容をもとに、2025 年 5 月 10 日時点での react-router-dom の最新バージョン (7.5.3) に対応した URL パラメータの記載方法や操作方法について解説します。

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

## パスパラメータ

React router の URL パラメータを説明する前に、パスパラメータについて説明しようと思います。
パスパラメータとは、URL の一部を変数のように扱える仕組みのことです。
例えば：

```
/users/:id
```

上記の `:id` はパスパラメータであり、URL が `/users/5` のときは `id = "5"` という値を取り出すことができます。

---

## 1. ルーティングの設定

React Router では、ルート定義に `:パラメータ名` を含めることでパスパラメータを定義できます。

```tsx
import { Routes, Route } from 'react-router-dom';
import UserDetail from './UserDetail';

<Routes>
  <Route path="/users/:id" element={<UserDetail />} />
</Routes>;
```

この設定により、`/users/1` や `/users/42` のような URL が `/users/:id` にマッチします。

---

## 2. useParams で取得

パスパラメータの値は、React Router の `useParams` フックを使って取得できます。

```jsx:UserDetail.jsx
import { useParams } from 'react-router-dom';

const UserDetail = ()=>{
  const { id } =useParams();
  return(
    <div>ユーザーID: {id}</div>
  )
}


```

この例では、`/users/3` にアクセスすると「ユーザー ID: 3」と表示されます。

---

## 3. ネストされたルーティングでの使用

ネストされたルートでも同様に `useParams()` で取得可能です。

```tsx
<Routes>
  <Route path="/users" element={<UsersLayout />}>
    <Route path=":id" element={<UserDetail />} />
  </Route>
</Routes>
```

`/users/10` にアクセスすると、`UserDetail` コンポーネントで `id` が取得できます。

---

## まとめ

| 項目       | 方法                               |
| ---------- | ---------------------------------- |
| 定義方法   | `<Route path="/users/:id" />`      |
| 取得方法   | `const { id } = useParams()`       |
| ネスト対応 | ネストされたルートでも同様に使える |

# 参考文献

https://www.udemy.com/share/104d6k3@42e714cVu4rgVDHDJf-ktUgk7fTCTCZNgNYDjNAfj2ycTQZlC2z-9pgXx7KV8hvxwQ==/
