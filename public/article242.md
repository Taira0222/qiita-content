---
title: 【react】useRef
tags:
  - 初心者
  - React
  - 未経験エンジニア
  - 独学
  - useRef
private: false
updated_at: '2025-05-30T12:09:53+09:00'
id: fc32acfcced5419d92ca
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在 React を学習中ですが、その中で最近ほかの Qiita 記事で目にした useRef について忘れないように記事にしようと思いました

## useRef とは

`useRef` は React のフックの一つで、次の性質を持ちます:

- **値が変わっても再レンダリングを起こさない**
- **DOM 要素や一度だけ生成したい値を保持できる**

これは「React から価の変化が見えない」「レンダリングのトリガーにならない」という特徴を持つためです。

---

## DOM 操作の例

```tsx
import { useRef } from 'react';

const Example = () => {
  const inputRef = useRef<HTMLInputElement>(null);

  const handleClick = () => {
    inputRef.current?.focus(); // ボタン押しでフォーカス
  };

  return (
    <>
      <input ref={inputRef} type="text" />
      <button onClick={handleClick}>入力段にフォーカス</button>
    </>
  );
};
```

- `useRef(null)` で初期値 null を指定
- 描画後に React が自動的に `inputRef.current` に DOM 要素を代入
- ボタン押下でその要素に `.focus()`

---

## 値を保持する例

```tsx
const renderCount = useRef(0);
renderCount.current += 1;
```

- これは再レンダリングごとに加算されますが
- `useState` と違って **レンダリングを起こしません**
- UI に関係しない一時的な値の管理に最適

---

## 使い分け

| 情報の性質                                    | 使うべきフック |
| --------------------------------------------- | -------------- |
| UI の表示に関わる                             | `useState`     |
| DOM を操作したい / 再レンダリングに無関係の値 | `useRef`       |

---

## まとめ

- `useRef` は **React に覚知されない値を保つ"不反応型の盗裏貯蓄所"**
- DOM の参照、値の保持、一度だけ作りたいものの保存などで活躍
- 再レンダリングと分離されたロジックを書きたいときの強力な味方
