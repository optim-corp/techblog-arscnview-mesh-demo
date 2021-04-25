#  ARSCNViewMeshDemo

## 概要

![capture.gif](./capture.gif)

このリポジトリは OPTiM TECH BLOG 記事「ARKit と LiDAR で 3 次元空間認識して SceneKit でリアルタイム描画」のサンプルコードです．

上記ブログ記事及びこのサンプルコードからは以下を学ぶことができます．

- `ARMeshAnchor` を SceneKit (`ARSCNView`) でリアルタイム描画する方法
- カラーピッカーで色を選択するとリアルタイムに線の色を変更する方法
- SwiftUI で `ARSCNView` を扱う方法

## 実行環境

AR 機能を用いるためシミュレータでは使用できません．

- Xcode 12 以降
- iOS/iPadOS 14 以降
- LiDAR スキャナ搭載の iPhone または iPad

## 実行方法

1. Xcode で ARSCNViewMeshDemo.xcodeproj を開く
1. 必要に応じてターゲット設定の "Signing & Capabilities" の "Team" と "Bundle Identifier" をあなたのものに変更
1. 実機デバッグで実行

## ライセンス

[MIT Licesne](./LICENSE)
