//
//  PongBox.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/27/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

class PongBox : SCNNode, PongPlatform, Randomable, Mathable {
    
    internal static var totalBoxes:Int! = 0
    
    private var type:PongBoxType!
    
    init(type: PongBoxType) {
        super.init()
        
        self.type = type
        let averageScore:Double = data.getAverageScore()
        let isAverage:Bool = PongBox.totalBoxes == Int(averageScore)
        
        name = "pongBox" + PongBox.totalBoxes.description
        geometry = getShape(type)
        geometry!.materials.first!.diffuse.contents = getRandomUIColor()
        
        let isSpring:Bool = type == .SPRING
        let shape:SCNPhysicsShape = SCNPhysicsShape(geometry: geometry!, options: nil)
        let body:SCNPhysicsBody = SCNPhysicsBody(type: .static, shape: shape)
        body.isAffectedByGravity = false
        body.categoryBitMask = isSpring ? BitMasks.PONG_SPRING : BitMasks.PONG_BOX
        body.collisionBitMask = BitMasks.PONG_BALL
        body.contactTestBitMask = BitMasks.PONG_BALL
        
        physicsBody = body
        PongBox.totalBoxes += 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getType() -> PongBoxType {
        return type
    }
    
    private func getShape(_ type: PongBoxType) -> SCNGeometry! {
        switch type {
        case .NORMAL: return getRandomShape(width: 4, height: 1, length: 2, cornerRadius: 5)
        case .SPRING: return SCNCylinder(radius: 1, height: 0.5)
        default: return nil
        }
    }
    private func getRandomShape(width: CGFloat, height: CGFloat, length: CGFloat, cornerRadius: CGFloat) -> SCNGeometry! {
        let random:Int = getRandomNumber(min: 0, max: 1)
        switch random {
        case 0:
            return SCNBox(width: width, height: height, length: length, chamferRadius: cornerRadius)
        case 1:
            eulerAngles = SCNVector3(toRadians(floatDegree: 180), 0, 0)
            return SCNPyramid(width: width, height: height*3, length: length)
        default: return nil
        }
    }
}

enum PongBoxType {
    case NORMAL
    case SPRING
}
