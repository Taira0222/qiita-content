---
title: 【React】React router とは
tags:
  - 初心者
  - React
  - Router
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-11T12:12:50+09:00'
id: f6c0817918d7ac354acb
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。

この講座の内容は非常にわかりやすいのですが、紹介されている React および React Router のバージョンがやや古く、現在主流となっている react-router-dom バージョン 7 とは操作方法が大きく異なります。

そこで本記事では、講座内で紹介されている内容をもとに、2025 年 5 月 10 日時点での react-router-dom の最新バージョン（7.5.3）に対応した書き方や操作方法について解説します。

【開発環境】
React 19.1.0

Vite 6.3.5

react-router-dom 7.5.3

## 始める前に

まずは react-router-dom をインストールしてください

```npm
npm install react-router-dom
```

package.json の dependencies に react-router-dom バージョン 7.5.3(2025 年 5 月時点)が入っていることを確認してください

## React router の使い方

以下はバージョン 7 の react-router-dom の書き方です。

```jsx:App.jsx
import {BrowserRouter, Route, Routes } from 'react-router-dom'
import { Home } from '../Home';
import { Page2 } from '../Page2';
import { Page1 } from '../Page1';
import { Page1DetailA } from '../Page1DetailA';
import { Page1DetailB } from '../Page1DetailB';
import { UrlParameter } from '../UrlParameter';
import { Page404 } from '../Page404';

export const App = ()=>{
  return(
    <>
      <BrowserRouter>
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
      </BrowserRouter>
    </>
  )
}
```

このように、v7 では Routes コンポーネントの中に Route をネストし、それぞれに element プロパティでコンポーネントを割り当てるというシンプルな記述になっています。

以下に、旧バージョン（v5）と比較して、v6 以降でどのように変わったかを表にまとめました。

| 項目               | v5 以前 | v6 以降（現行）           | 変化のポイント                                 |
| ------------------ | ------- | ------------------------- | ---------------------------------------------- |
| Switch             | ✅ 使用 | ❌ 廃止 → Routes          | 自動で最初にマッチしたルートだけ表示（明確化） |
| exact              | ✅ 必須 | ❌ 不要                   | パスの完全一致がデフォルトに                   |
| component / render | ✅ 使用 | ❌ 廃止 → element={<...>} | JSX の一貫性向上、直感的に                     |
|                    |         |                           |                                                |

私は講座内で紹介されていた v5 の書き方を見ましたが、v7 以降の書き方のほうがシンプルで可読性が高く、初心者にも理解しやすいと感じました。

## まとめ

本記事では、React Router v7 における基本的なルーティングの書き方と、旧バージョンとの主な違いについてまとめました。
今後はさらに詳細な使い方についても記事にしていく予定です。

# 参考文献

https://www.udemy.com/share/104d6k3@42e714cVu4rgVDHDJf-ktUgk7fTCTCZNgNYDjNAfj2ycTQZlC2z-9pgXx7KV8hvxwQ==/
