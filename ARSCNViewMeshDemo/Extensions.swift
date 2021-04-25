//
//  Extensions.swift
//  ARSCNViewMeshDemo
//
//  Created by OPTiM Corp. on 4/25/21.
//

import ARKit
import SceneKit

extension SCNGeometry {
    convenience init(from meshGeometry: ARMeshGeometry) {
        // Vertices source
        let vertices = meshGeometry.vertices
        let verticesSource = SCNGeometrySource(
            buffer: vertices.buffer,
            vertexFormat: vertices.format,
            semantic: .vertex,
            vertexCount: vertices.count,
            dataOffset: vertices.offset,
            dataStride: vertices.stride
        )

        // Indices element
        let faces = meshGeometry.faces
        let facesElement = SCNGeometryElement(
            data: Data(
                bytesNoCopy: faces.buffer.contents(),
                count: faces.buffer.length,
                deallocator: .none
            ),
            primitiveType: .triangles,
            primitiveCount: faces.count,
            bytesPerIndex: faces.bytesPerIndex
        )

        self.init(
            sources: [verticesSource],
            elements: [facesElement]
        )
    }
}
