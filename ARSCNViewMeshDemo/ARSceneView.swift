//
//  ARSceneView.swift
//  ARSCNViewMeshDemo
//
//  Created by OPTiM Corp. on 4/25/21.
//

import ARKit
import SceneKit
import SwiftUI

struct ARSceneView {
    @Binding var session: ARSession
    @Binding var scene: SCNScene
    @Binding var lineColor: Color
}

extension ARSceneView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        ARSCNView(frame: .zero)
    }

    func makeCoordinator() -> Self.Coordinator {
        Self.Coordinator(scene: self.$scene, lineColor: self.$lineColor)
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if uiView.session != self.session {
            uiView.session.delegate = nil
            uiView.session = self.session
            uiView.session.delegate = context.coordinator
        }
        uiView.scene = self.scene
    }
}

extension ARSceneView {
    final class Coordinator: NSObject {
        @Binding var scene: SCNScene
        @Binding var lineColor: Color
        var knownAnchors = [UUID: SCNNode]()

        init(scene: Binding<SCNScene>, lineColor: Binding<Color>) {
            self._scene = scene
            self._lineColor = lineColor
        }
    }
}

extension ARSceneView.Coordinator: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors.compactMap({ $0 as? ARMeshAnchor }) {
            // anchor を SCNGeometry に変換
            let scnGeometry = SCNGeometry(from: anchor.geometry)

            // 見た目を指定
            let defaultMaterial = SCNMaterial()
            defaultMaterial.fillMode = .lines  // ワイヤーフレームのように線で描画
            defaultMaterial.diffuse.contents = self.lineColor.cgColor  // 線の色は指定色
            scnGeometry.materials = [defaultMaterial]

            // SCNGeometry から SCNNode 作成
            let node = SCNNode(geometry: scnGeometry)
            node.simdTransform = anchor.transform

            // SCNNode を描画 (arSCNView は ARSCNView のインスタンス)
            self.scene.rootNode.addChildNode(node)

            // knownAnchors に記憶させる
            self.knownAnchors[anchor.identifier] = node
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors.compactMap({ $0 as? ARMeshAnchor }) {
            // knownAnchors から UUID が一致するものを探す
            if let node = self.knownAnchors[anchor.identifier] {
                // 再度 SCNGeometry を作り直す
                let scnGeometry = SCNGeometry(from: anchor.geometry)

                // 見た目を指定
                let defaultMaterial = SCNMaterial()
                defaultMaterial.fillMode = .lines  // ワイヤーフレームのように線で描画
                defaultMaterial.diffuse.contents = self.lineColor.cgColor  // 線の色は指定色
                scnGeometry.materials = [defaultMaterial]

                // 描画中の SCNNode を更新
                node.geometry = scnGeometry
                node.simdTransform = anchor.transform
            }
        }
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors.compactMap({ $0 as? ARMeshAnchor }) {
            // knownAnchors から UUID が一致するものを探す
            if let node = self.knownAnchors[anchor.identifier] {
                // ARSCNView 上から SCNNode を消す
                node.removeFromParentNode()
                // knownAnchors からも削除
                self.knownAnchors.removeValue(forKey: anchor.identifier)
            }
        }
    }
}

struct ARSceneView_Previews: PreviewProvider {
    static var previews: some View {
        ARSceneView(
            session: .constant(ARSession()),
            scene: .constant(SCNScene()),
            lineColor: .constant(.white)
        )
    }
}
