//
//  Paddle.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/1/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

class Paddle : SCNNode, Randomable, Mathable {
    
    private var type:PaddleType!
    
    override init() {
        super.init()
        
        geometry = getShape()
        geometry!.materials.first!.diffuse.contents = getRandomUIColor()
        
        let shape:SCNPhysicsShape = SCNPhysicsShape(geometry: geometry!, options: nil)
        let body:SCNPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
        body.categoryBitMask = BitMasks.PADDLE
        body.collisionBitMask = BitMasks.PONG_BALL
        body.contactTestBitMask = BitMasks.PONG_BALL
        body.isAffectedByGravity = false
        physicsBody = body
        
        rotate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rotate() {
        runAction(SCNActions.PADDLE_ROTATION)
    }
    
    public func getType() -> PaddleType {
        return type
    }
    
    private func getShape() -> SCNGeometry! {
        let random:Int = 0//getRandomNumber(min: 0, max: 4)
        switch random {
        case 0:
            type = PaddleType.BOX
            return SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        case 1:
            type = PaddleType.PYRAMID
            return SCNPyramid(width: 1, height: 1, length: 1)
        case 2:
            type = PaddleType.TORUS
            eulerAngles = SCNVector3(toRadians(floatDegree: 90), 0, 0)
            return SCNTorus(ringRadius: 0.5, pipeRadius: 0.25)
        case 3:
            type = PaddleType.CAPSULE
            eulerAngles = SCNVector3(toRadians(floatDegree: 90), 0, 0)
            return SCNCapsule(capRadius: 0.5, height: 2)
        case 4:
            type = PaddleType.OCTAHEDRON
            return SCNCustomGeometry(.OCTAHEDRON).build()
        default:
            return nil
        }
    }
}
