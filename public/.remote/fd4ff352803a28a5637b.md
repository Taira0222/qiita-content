---
title: 【React】Memo
tags:
  - メモ
  - 初心者
  - React
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-21T12:10:12+09:00'
id: fd4ff352803a28a5637b
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。
その講座出てきた memo について記事にしていこうと思います

## memo とは？

`memo` とは、React の関数コンポーネントをメモ化（キャッシュ）することで、**props が変わらない限り再レンダリングを防ぐ**ための高階コンポーネントです。

### 使い方

```jsx
import { memo } from 'react';

export const MyComponent = memo((props) => {
  // 何らかの処理
  return <div>{props.value}</div>;
});
```

上記のように `memo` でラップするだけで、**親コンポーネントが再レンダリングされても、props が変わらなければ再描画されません。**

---

## なぜ memo が必要？

React では、親コンポーネントが再レンダリングされると、子コンポーネントもデフォルトで再レンダリングされます。しかし、子コンポーネントの props が変わっていない場合でも再レンダリングされてしまい、パフォーマンスの低下に繋がります。

特に大きなリストや、重い処理が入っているコンポーネントで memo を使うことで、**無駄な描画を防ぎ、アプリのレスポンスを良くすることができます。**

---

## memo の使いどころ

- **表示専用のコンポーネント**で、props の変更以外で再レンダリングの必要がないもの
- **リスト表示**で、個々のアイテムコンポーネントに渡す場合
- **重い計算処理**や描画処理があるコンポーネント

---

## 注意点と落とし穴

### 1. props の比較は「shallow equal」

`memo` は props を「浅い比較（shallow equal）」で判定します。

- オブジェクトや配列を毎回新しく生成して渡していると、値が同じでも「違うもの」として判定されてしまい、再レンダリングされます。

例

```jsx
import { useState, useCallback, memo } from 'react';

// 子コンポーネントをmemoでラップ
const Child = memo(({ onClick }) => {
  console.log('Child rendered');
  return <button onClick={onClick}>子のボタン</button>;
});

const Parent = () => {
  const [count, setCount] = useState(0);

  // useCallbackで関数をメモ化
  const handleClick = () => {
    alert('クリックされました！');
  };

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>親のボタン（{count}）</button>
      <Child onClick={handleClick} />
    </div>
  );
};

export default Parent;
```

親のボタンというボタンを押す際に、本来は`handleClick`は呼び出されていません。しかし、上記のままだと、Child という子コンポーネントで memo を使用していても子コンポーネントで再レンダリングされてしまいます。

これは、`handleClick`がレンダリングごとに生成されて、関数の内容は同じだとしてもまったく新しいものとしてみなされ再レンダリングされるのです。

#### 解決方法

```jsx
import { useState, useCallback, memo } from 'react';

// 子コンポーネントをmemoでラップ
const Child = memo(({ onClick }) => {
  console.log('Child rendered');
  return <button onClick={onClick}>子のボタン</button>;
});

const Parent = () => {
  const [count, setCount] = useState(0);

  // useCallbackで関数をメモ化
  const handleClick = useCallback(() => {
    alert('クリックされました！');
  }, []); // 依存配列が空なので常に同じ関数

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>親のボタン（{count}）</button>
      <Child onClick={handleClick} />
    </div>
  );
};

export default Parent;
```

今回は`useCallback`という react ライブラリにあるコンポーネントを使用しています。
useEffect と同様に、第二引数に配列をとりその指定した配列に更新があった際に再レンダリングする性質を持っています。

ややこしいので、useCallback と useEffect の違いをまとめておきます。

|                    | useCallback                                             | useEffect                                             |
| ------------------ | ------------------------------------------------------- | ----------------------------------------------------- |
| **用途**           | 関数をメモ化（同じ参照を保つ）                          | 副作用（副次的な処理）を実行する                      |
| **いつ使う？**     | イベントハンドラやコールバック関数を props で渡す時など | データ取得、DOM 操作、外部 API 通信、タイマー設定など |
| **戻り値**         | メモ化された関数                                        | なし（return でクリーンアップ関数を返すことはできる） |
| **依存配列**       | 依存配列が変わった時だけ新しい関数を作る                | 依存配列が変わった時だけ副作用処理を再実行する        |
| **代表的な使い方** | `const fn = useCallback(() => {...}, [deps])`           | `useEffect(() => {...}, [deps])`                      |

### 2. 状態やコンテキストの変更には効かない

- `useState` や `useContext` で取得した値が変わると、`memo` していても再レンダリングされます。

### 3. 不要な箇所で使いすぎない

- 全てのコンポーネントで使うと逆にオーバーヘッドが増えるため、「本当に再レンダリングを減らしたい部分」に限定しましょう。

## まとめ

- `memo` は「関数コンポーネントの再レンダリング最適化」のための仕組み
- props が変わらない限り再レンダリングされなくなる
- オブジェクトや配列の shallow equal、不要な箇所での多用には注意
- 重いコンポーネントやリストで使うのが効果的
