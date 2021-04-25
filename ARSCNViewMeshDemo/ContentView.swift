//
//  ContentView.swift
//  ARSCNViewMeshDemo
//
//  Created by OPTiM Corp. on 4/25/21.
//

import ARKit
import SwiftUI
import SceneKit

struct ContentView {
    @State var session: ARSession
    @State var scene: SCNScene
    @State var lineColor = Color.white

    init() {
        let session = ARSession()
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .mesh
        session.run(configuration)
        self.session = session

        self.scene = SCNScene()
    }
}

extension ContentView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ARSceneView(
                session: self.$session,
                scene: self.$scene,
                lineColor: self.$lineColor
            )
            .ignoresSafeArea()

            ColorPicker("Line Color", selection: self.$lineColor)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
