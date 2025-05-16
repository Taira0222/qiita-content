---
title: 【React】React routerのLinkを使用しないページ遷移(useNavigate)
tags:
  - 初心者
  - React
  - Router
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-16T12:10:44+09:00'
id: 048ac8c70863ca3d2822
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。

この講座の内容は非常にわかりやすいのですが、紹介されている React および React Router のバージョンがやや古く、現在主流となっている react-router-dom バージョン 7 とは操作方法が大きく異なります。

そこで本記事では、講座内で紹介されている内容をもとに、2025 年 5 月 10 日時点での react-router-dom の最新バージョン (7.5.3) に対応した useNavigate について解説します。

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

### useNavigate の使い方

```jsx
import { useNavigate } from 'react-router-dom';

const MyComponent = () => {
  const navigate = useNavigate();

  const handleClick = () => {
    navigate('/about');
  };

  return <button onClick={handleClick}>Go to About</button>;
};
```

`navigate('/about')`のように、URL を指定するだけでそのページへ遷移します。

---

## 戦略的な使い方

### 1. 戻る

```jsx
navigate(-1); // 1順戻る
```

### 2. state を渡す

```jsx
navigate('/user', { state: { id: 123 } });
```

渡された state は `useLocation()` で取得できます:

```jsx
const location = useLocation();
console.log(location.state.id); // 123
```

### 3. replace

`replace: true`を指定すると、ヒストリの戻る編にたまらない

```jsx
navigate('/dashboard', { replace: true });
```

---

## コンポーネントとの違い

| 順序 | `<Link>`                          | `useNavigate`                    |
| ---- | --------------------------------- | -------------------------------- |
| 1    | JSX 上で簡単に記述                | JavaScript 内で自由に制御        |
| 2    | 表示は `<a>` のような指し方       | 押した時に移動するように動的制御 |
| 3    | state, replace は使わない事も多い | 突発的な移動に適する             |

---

## まとめ

`useNavigate`を使うことで、ユーザー操作や出力結果に応じて、動的にページ遷移を実現できるようになります。

- ボタン押下時
- ログイン成功時
- API 通信結果に応じた遷移

などのシーンで有効に活用できます。

# 参考文献

https://www.udemy.com/share/104d6k3@42e714cVu4rgVDHDJf-ktUgk7fTCTCZNgNYDjNAfj2ycTQZlC2z-9pgXx7KV8hvxwQ==/
