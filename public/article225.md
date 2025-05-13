---
title: 【React】React router ルート分割
tags:
  - 初心者
  - React
  - Router
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-13T12:10:05+09:00'
id: 883aa7d22cbf0d3a08de
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。

この講座の内容は非常にわかりやすいのですが、紹介されている React および React Router のバージョンがやや古く、現在主流となっている react-router-dom バージョン 7 とは操作方法が大きく異なります。

そこで本記事では、講座内で紹介されている内容をもとに、2025 年 5 月 10 日時点での react-router-dom の最新バージョン (7.5.3) に対応したルート分割の記載方法や操作方法について解説します。

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

## React Router ルート分割

以下は、前の記事で書いていたルーティングです。

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
      <div className="App">
        <Link to="/">Home</Link>
        <br />
        <Link to="/page1">Page1</Link>
        <br />
        <Link to="/page2">Page2</Link>
      </div>
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

上記のような記述でも問題はありませんが、このままでは App.jsx にルーティングも他のコンポーネントも含まれてしまい、要素が増えてしまいます。

React の魅力は、コンポーネント分割が可能な点にあります。そこで、ルーティング部分は router/Router.jsx に分離して管理する方式が「ルート分割」です。

```jsx:Router.jsx
import { Route, Routes } from 'react-router-dom';
import { Home } from '../Home';
import { Page2 } from '../Page2';
import { Page1 } from '../Page1';
import { Page1DetailA } from '../Page1DetailA';
import { Page1DetailB } from '../Page1DetailB';
import { UrlParameter } from '../UrlParameter';
import { Page404 } from '../Page404';

export const Router = () => {
  return (
    <>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/page1" element={<Page1 />}>
          <Route path="detailA" element={<Page1DetailA />} />
          <Route path="detailB" element={<Page1DetailB />} />
        </Route>

        <Route path="/page2" element={<Page2 />}>
          <Route path=":id" element={<UrlParameter />} />
        </Route>

        <Route path="*" element={<Page404 />} />
      </Routes>
    </>
  );
};
```

そして App.jsx 側で Router.jsx を呼び出すことで、ルート分割の完成です。

```jsx:App.jsx
import { BrowserRouter, Link } from 'react-router-dom';
import { Router } from './router/Router';

import './App.css';

const App = () => {
  return (
    <>
      <BrowserRouter>
        <div className="App">
          <Link to="/">Home</Link>
          <br />
          <Link to="/page1">Page1</Link>
          <br />
          <Link to="/page2">Page2</Link>
        </div>
        <Router />
      </BrowserRouter>
    </>
  );
};

export default App;
```

## まとめ

本記事では、React Router v7 のネスト記載について、基本的な使い方を解説しました。

次回の記事では URL パラメータについて紹介しようと思います。

# 参考文献

https://www.udemy.com/share/104d6k3@42e714cVu4rgVDHDJf-ktUgk7fTCTCZNgNYDjNAfj2ycTQZlC2z-9pgXx7KV8hvxwQ==/
