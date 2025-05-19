---
title: 【React】contextAPI
tags:
  - 初心者
  - ConTeXt
  - React
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-19T12:16:11+09:00'
id: 71ac69377892e126aa25
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。
その中で出てきた contentAPI について記事を書こうと思います。
React で搭載されているグローバル state を管理するために使用できるライブラリです。

---

## 1. Context API とは？

React の Context API は、コンポーネント間で「データ」や「状態」を共有するための仕組みです。通常、親から子へ props でデータを渡しますが、コンポーネントが多くなってくると、props のバケツリレー（prop drilling）でコードが煩雑になります。Context API を使えば、ツリー内のどこからでも必要なデータにアクセスできるようになります。

---

## 2. どんな時に使う？

- グローバルなテーマ（ダークモード・ライトモードの切り替え）
- ログインユーザー情報の管理
- 多言語対応（i18n）
- アプリ全体で使う設定値

など、複数コンポーネントで共通して使いたい情報を扱うときに便利です。

---

## 3. 基本的な使い方

Context API の基本的な流れは次の 3 ステップです。

1. **Context の作成**
2. **Provider で値を渡す**
3. **Consumer または useContext で値を取得する**

### 3-1. Context の作成

```jsx
import { createContext } from 'react';

const MyContext = createContext(defaultValue);
```

### 3-2. Provider で値を渡す

```jsx
<MyContext.Provider value={value}>
  <YourComponent />
</MyContext.Provider>
```

### 3-3. useContext で値を取得する（React v16.8 以降）

```jsx
import { useContext } from 'react';

const value = useContext(MyContext);
```

---

## 4. サンプルコード

### 例：テーマ切り替え

```jsx
// ThemeContext.js
import React, { createContext, useState, useContext } from 'react';

const ThemeContext = createContext();

export const ThemeProvider = ({ children }) => {
  const [theme, setTheme] = useState('light');
  const toggleTheme = () => setTheme(theme === 'light' ? 'dark' : 'light');

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = () => useContext(ThemeContext);
```

```jsx
// App.js
import React from 'react';
import { ThemeProvider, useTheme } from './ThemeContext';

const ThemeSwitcher = () => {
  const { theme, toggleTheme } = useTheme();
  return (
    <button onClick={toggleTheme}>
      現在のテーマ: {theme}（クリックで切り替え）
    </button>
  );
};

const App = () => (
  <ThemeProvider>
    <ThemeSwitcher />
  </ThemeProvider>
);

export default App;
```

---

## 5. Context API の注意点

- **再レンダリングに注意**: Context の値が変わると、その Context を使っているすべてのコンポーネントが再レンダリングされます。大きな値や頻繁に変わる値を Context に入れるとパフォーマンスに影響する場合があります。
- **必要以上に使わない**: すべての状態を Context で管理すると逆に管理が複雑になることもあるので、基本は props や state、必要な場合だけ Context を使いましょう。

---

## 6. Context API と他の状態管理ライブラリの違い

Context API は「グローバル状態共有」の仕組みですが、Redux や Zustand のような高度な状態管理のための機能は持っていません。
中～大規模アプリや複雑な状態遷移を扱う場合は、これらのライブラリと併用することも多いです。
個人的には、ポートフォリオには煩雑さや再レンダリング等のことを踏まえると次の記事で紹介する Zustand を搭載する予定です。

---

## 7. まとめ

- Context API は、React でグローバルに値を共有するシンプルな仕組み
- props のバケツリレーを避けたいときや、複数コンポーネントで同じ情報を扱うときに便利
- 頻繁に変わるデータや複雑なロジックには他の状態管理ライブラリを検討

## 参考文献

https://www.udemy.com/course/react_stepup/?couponCode=CP130525JP
