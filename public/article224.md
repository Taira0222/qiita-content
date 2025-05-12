---
title: 【React】React router ネストで書く場合
tags:
  - 初心者
  - React
  - Router
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-12T12:12:22+09:00'
id: 5a41e4a2eab338357830
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。

この講座の内容は非常にわかりやすいのですが、紹介されている React および React Router のバージョンがやや古く、現在主流となっている react-router-dom バージョン 7 とは操作方法が大きく異なります。

そこで本記事では、講座内で紹介されている内容をもとに、2025 年 5 月 10 日時点での react-router-dom の最新バージョン (7.5.3) に対応したネスト記載方法や操作方法について解説します。

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

## React Router ネストの書き方

以下は、react-router-dom v7 における基本的な記載例です:

```jsx:App.jsx
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { Home } from '../Home';
import { Page2 } from '../Page2';
import { Page1 } from '../Page1';
import { Page1DetailA } from '../Page1DetailA';
import { Page1DetailB } from '../Page1DetailB';
import { UrlParameter } from '../UrlParameter';
import { Page404 } from '../Page404';

export const App = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/page1" element={<Page1 />}>
          <Route path="detailA" element={<Page1DetailA />} />
          <Route path="detailB" element={<Page1DetailB />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
};
```

このように v7 では、`<Routes>` の中に `<Route>` をネストして、それぞれに `element` プロパティで表示するコンポーネントを指定する、直感的で分かりやすい記載方式に変更されています。

上記のコードでは、`/page1/detailA` と `/page1/detailB` の 2 つのルートが `/page1` にネストされています。

以下は `Page1` コンポーネントのコードです:

```jsx:Page1.jsx
import { Link, Outlet, useNavigate } from 'react-router-dom';

export const Page1 = () => {
  const arr = [...Array(100).keys()];
  const navigate = useNavigate();
  const onClickDetailA = () => navigate('detailA');

  return (
    <>
      <div>
        <h1>Page1ページです</h1>
        <Link to="detailA" state={arr}>DetailA</Link>
        <br />
        <Link to="detailB">DetailB</Link>
        <br />
        <button onClick={onClickDetailA}>DetailA</button>
      </div>
      <Outlet />
    </>
  );
};
```

`<Outlet />` は、ネストされたルートの表示空間を指定するプレースホルダーです。例えば `/page1/detailA` にアクセスすると、`Page1` コンポーネント内の `<Outlet />` の位置に `Page1DetailA` が表示されます。

## まとめ

本記事では、React Router v7 のネスト記載について、基本的な使い方を解説しました。

次回の記事ではルート分割について紹介しようと思います。

# 参考文献

https://www.udemy.com/share/104d6k3@42e714cVu4rgVDHDJf-ktUgk7fTCTCZNgNYDjNAfj2ycTQZlC2z-9pgXx7KV8hvxwQ==/
