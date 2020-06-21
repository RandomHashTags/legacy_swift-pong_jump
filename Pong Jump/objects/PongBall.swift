//
//  PongBall.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/27/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

class PongBall : SCNNode, Randomable, Mathable {
    
    private var texture:PongBallTexture!
    
    init(texture: PongBallTexture) {
        self.texture = texture
        super.init()
        name = "pongBall"
        
        setTexture(texture)
        let shape:SCNPhysicsShape = SCNPhysicsShape(geometry: geometry!, options: nil)
        let body:SCNPhysicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        body.isAffectedByGravity = false
        body.allowsResting = false
        body.mass = 1.00
        body.damping = 0.00
        body.friction = 0.00
        body.restitution = 0.00
        body.angularDamping = 0.00
        body.categoryBitMask = BitMasks.PONG_BALL
        body.collisionBitMask = BitMasks.PONG_BOX
        body.contactTestBitMask = BitMasks.PONG_BOX
        physicsBody = body
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getTexture() -> PongBallTexture {
        return texture
    }
    public func setTexture(_ pongBallTexture: PongBallTexture!) {
        if pongBallTexture == nil {
            texture = nil
        } else {
            let value:NSObject! = pongBallTexture.getValue()
            texture.setColor(value != nil ? value : pongBallTexture.getColor())
            if let geo = pongBallTexture.getGeometry() {
                texture.setGeometry(geo)
            }
            geometry = texture.getGeometry()
            geometry!.materials.first!.diffuse.contents = texture.getColor()
            
            if let angles = pongBallTexture.getEulerAngles() {
                eulerAngles = angles
            }
        }
    }
    
    public func update() {
        if texture == .COLOR_ADAPTIVE {
            let score:String = scoreboard.getScore().description
            let targetNode:SCNNode = GAME_CONTROLLER.scene.rootNode.childNode(withName: "pongBox" + score, recursively: false)!
            geometry!.materials.first!.diffuse.contents = targetNode.geometry!.materials.first!.diffuse.contents
        }
    }
}
