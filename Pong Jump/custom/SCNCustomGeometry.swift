//
//  SCNCustomGeometry.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/10/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

struct SCNCustomGeometry {
    private var type:SCNCustomGeometryType
    init(_ type: SCNCustomGeometryType) {
        self.type = type
    }
    
    func build() -> SCNGeometry {
        let geometry:SCNCustomGeometryHolder = getGeometry()
        return SCNGeometry(sources: geometry.getSources(), elements: [geometry.getElement()])
    }
    
    private func getGeometry() -> SCNCustomGeometryHolder! {
        switch type {
        case .OCTAHEDRON: return Octahedron()
        case .ICOSAHEDRON: return Icosahedron()
        default: return nil
        }
    }
}

enum SCNCustomGeometryType {
    case OCTAHEDRON
    case ICOSAHEDRON
}

private protocol SCNCustomGeometryHolder : Randomable {
    func getPrimitiveType() -> SCNGeometryPrimitiveType
    func getVertices(width: Float, height: Float) -> [SCNVector3]
    func getIndices() -> [UInt16]
    func getSources() -> [SCNGeometrySource]
    func getElement() -> SCNGeometryElement
}

private protocol SCNCustomDefaultGeometryHolder : SCNCustomGeometryHolder {
}
extension SCNCustomDefaultGeometryHolder {
    func getSources() -> [SCNGeometrySource] {
        return [SCNGeometrySource(vertices: getVertices(width: 0.5, height: 1))]
    }
    func getElement() -> SCNGeometryElement {
        return SCNGeometryElement(indices: getIndices(), primitiveType: getPrimitiveType())
    }
}

private struct Octahedron : SCNCustomDefaultGeometryHolder {
    func getPrimitiveType() -> SCNGeometryPrimitiveType {
        return .triangles
    }
    func getVertices(width: Float, height: Float) -> [SCNVector3] {
        return [
            SCNVector3(0, height, 0),
            SCNVector3(-width, 0, width),
            SCNVector3(width, 0, width),
            SCNVector3(width, 0, -width),
            SCNVector3(-width, 0, -width),
            SCNVector3(0, -height, 0)
        ]
    }
    func getIndices() -> [UInt16] {
        return [
            0, 1, 2,
            2, 3, 0,
            3, 4, 0,
            4, 1, 0,
            1, 5, 2,
            2, 5, 3,
            3, 5, 4,
            4, 5, 1
        ]
    }
}

private struct Icosahedron : SCNCustomGeometryHolder {
    func getPrimitiveType() -> SCNGeometryPrimitiveType {
        return .line
    }
    func getVertices(width: Float, height: Float) -> [SCNVector3] {
        return [
            SCNVector3(-width, height, 0),
            SCNVector3(width, height, 0),
            SCNVector3(-width, -height, 0),
            SCNVector3(width, -height, 0),
            
            SCNVector3(0, -height, width),
            SCNVector3(0, height, width),
            SCNVector3(0, -height, -width),
            SCNVector3(0, height, -width),
            
            SCNVector3(width, 0, -width),
            SCNVector3(width, 0, width),
            SCNVector3(-width, 0, -width),
            SCNVector3(-width, 0, width)
        ]
    }
    func getIndices() -> [UInt16] {
        return [
            0, 5, 1,
            0, 1, 5,
            1, 7, 1,
            8, 1, 9,
            2, 3, 2,
            4, 2, 6,
            2, 10, 2,
            11, 3, 6,
            3, 8, 3,
            9, 4, 3,
            4, 5, 4,
            9, 5, 9,
            6, 7, 6,
            8, 6, 10,
            9, 8, 8,
            7, 7, 0,
            10, 0, 10,
            7, 10, 11,
            11, 0, 11,
            4, 11, 5
        ]
    }
    func getSources() -> [SCNGeometrySource] {
        let vertices:[SCNVector3] = getVertices(width: 1, height: 1)
        let verticesCount:Int = vertices.count
        let length:Int = MemoryLayout<SCNVector3>.size * verticesCount
        let dataStride:Int = MemoryLayout<SCNVector3>.stride, bytesPerComponent:Int = MemoryLayout<Float>.size
        let data:Data = NSData(bytes: vertices, length: length) as Data
        
        var vertexColors = [SCNVector3]()
        for _ in 0..<verticesCount {
            let red:Int = getRandomNumber(min: 0, max: 255), green:Int = getRandomNumber(min: 0, max: 255), blue:Int = getRandomNumber(min: 0, max: 255)
            vertexColors.append(SCNVector3(red, green, blue))
        }
         
        let dataColor:Data = NSData(bytes: vertexColors, length: length) as Data
        return [
            SCNGeometrySource(data: data, semantic: .vertex, vectorCount: verticesCount, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: bytesPerComponent, dataOffset: 0, dataStride: dataStride),
            SCNGeometrySource(data: dataColor, semantic: .color, vectorCount: vertexColors.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: bytesPerComponent, dataOffset: 0, dataStride: dataStride)
        ]
    }
    
    func getElement() -> SCNGeometryElement {
        let indices:[UInt16] = getIndices()
        let indicesCount:Int = indices.count, length:Int = MemoryLayout<Int16>.size
        let indexData:Data = NSData(bytes: indices, length: length * indicesCount) as Data
        return SCNGeometryElement(data: indexData, primitiveType: getPrimitiveType(), primitiveCount: indicesCount/2, bytesPerIndex: length)
    }
}
