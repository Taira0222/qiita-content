---
title: 【React】Zustand
tags:
  - 初心者
  - React
  - 未経験エンジニア
  - 独学
  - zustand
private: false
updated_at: '2025-05-20T12:10:42+09:00'
id: 3d80473aca9d06841129
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Udemy の講座「React に入門した人のためのもっと React が楽しくなるステップアップコース完全版」で React の学習を進めています。
上記講座では ContentAPI 以外に、Recoil ライブラリでグローバル state を管理できると紹介されていたのですが、よくよく調べると Recoil は 2025 年 1 月 1 日にソースコードが読み込み専用(おそらくこれ以上の開発はない?)になっていたため、自分で調べたところ Zustand というライブラリが useState みたいに使用できてはやっていると聞きました
本日は Zustand について記事を書いていきたいと思います

## Zustand の特徴

- **シンプルな API**

  - Redux や Recoil と比較して圧倒的にシンプルな記述で導入できます。
  - Provider や Context の設定が不要。

- **高パフォーマンス**

  - レンダリングの最適化が自動的に行われる。

- **Typescript 対応**

  - 型安全な記述が可能。

- **React 以外でも利用可能**

  - 状態のロジックは React に依存していないため、外部からも直接操作が可能。

---

## インストール方法

```bash
npm install zustand
```

または

```bash
yarn add zustand
```

---

## 基本的な使い方

1. **ストアの作成**

```tsx
import { create } from 'zustand';

// ストアの定義
type State = {
  count: number;
  increment: () => void;
};

export const useStore = create<State>((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
}));
```

ここでの state は「Zustand のストアに格納されている“今この瞬間の値”」です。

例えば、ストアが { count: 3, increment: f } の状態だった場合、

- set((state) => ({ count: state.count + 1 })) が呼ばれると
- state には { count: 3, increment: f } がそのまま渡ります。
- その中の count を 1 つ増やしたオブジェクトを返しているイメージです。

2. **コンポーネントでの利用**

```tsx
import { useStore } from './store';

const Counter = () => {
  const count = useStore((state) => state.count);
  const increment = useStore((state) => state.increment);
  return (
    <div>
      <h1>{count}</h1>
      <button onClick={increment}>+1</button>
    </div>
  );
};
```

- それぞれ必要な state だけをセレクタ（関数）で取得しています。
- 例えば count が変わっても increment 関数自体は変わらないので、count だけで再レンダリングが起き、他の state は無視される。
- 大規模アプリやパフォーマンス重視の時は、必要な state だけ取得するのがベストプラクティスです。
- 無駄な再レンダリングを防げるので、効率が良い。

---

## 他の状態管理ライブラリとの比較

| ライブラリ | 特徴                               | 学習コスト | パフォーマンス | 規模           |
| :--------- | :--------------------------------- | :--------- | :------------- | :------------- |
| Redux      | 業界標準、エコシステム豊富         | 高         | 高             | 大規模向き     |
| Recoil     | アトミックな状態管理、依存関係管理 | 中         | 中             | 中規模〜大規模 |
| Zustand    | シンプル、軽量、柔軟               | 低         | 高             | 小〜中規模     |
| Jotai      | 最小限で直感的な API               | 低         | 高             | 小〜中規模     |

---

## メリット・デメリット

### メリット

- コード量が少なく、直感的に書ける
- Redux のようなボイラープレートが不要
- パフォーマンスが良い
- Context API や Provider が不要

### デメリット

- 巨大なアプリでは設計によって管理が煩雑になる場合がある
- 状態の変更を追跡したい（DevTools 等）場合、Redux に比べて若干弱い

---

## まとめ

Zustand は「小〜中規模のアプリ」や「とにかくシンプルにグローバルステートを管理したい」場合に最適なライブラリです。
公式ドキュメントも非常に分かりやすいので、まずは簡単なアプリで導入してみることをおすすめします。

---

## 参考リンク

https://github.com/pmndrs/zustand
