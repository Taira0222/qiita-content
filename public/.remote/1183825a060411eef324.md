---
title: 【React】React router 404page
tags:
  - 初心者
  - React
  - Router
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-17T12:05:34+09:00'
id: 1183825a060411eef324
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。

この講座の内容は非常にわかりやすいのですが、紹介されている React および React Router のバージョンがやや古く、現在主流となっている react-router-dom バージョン 7 とは操作方法が大きく異なります。

そこで本記事では、講座内で紹介されている内容をもとに、2025 年 5 月 10 日時点での react-router-dom の最新バージョン (7.5.3) に対応した 404 ページ について解説します。

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

## 1. 404 ページ用のコンポーネントを作成

まずは、NotFound ページ用のコンポーネントを作成します。

```jsx
// src/pages/NotFound.jsx
export const NotFound = () => {
  return (
    <div style={{ textAlign: 'center', padding: '40px' }}>
      <h1>404 - Page Not Found</h1>
      <p>お探しのページは存在しません。</p>
    </div>
  );
};
```

---

## 2. ルーティング設定に"\*"を追加

React Router では、存在しないパスに対応するルートとして`path="*"`を指定することで、NotFound ページを表示できます。

```jsx
// src/App.jsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Home } from './pages/Home';
import { About } from './pages/About';
import { NotFound } from './pages/NotFound';

export const App = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
};
```

このように、最後に`path="*"`を追加することで、どのルートにもマッチしなかった URL はすべて`<NotFound />`が表示されるようになります。

---

## 3. 補足：ネストされたルートでも使える？

ネストされたルート構成でも、親の`<Route>`の中に`<Route path="*" element={<NotFound />} />`を記述することで、子ルートにマッチしなかったときに対応可能です。

---

## おわりに

404 ページの実装は非常に簡単ですが、用意しておくことでユーザーが迷子になったときにも安心してサイトを利用してもらえるようになります。

# 参考文献

https://www.udemy.com/share/104d6k3@42e714cVu4rgVDHDJf-ktUgk7fTCTCZNgNYDjNAfj2ycTQZlC2z-9pgXx7KV8hvxwQ==/
