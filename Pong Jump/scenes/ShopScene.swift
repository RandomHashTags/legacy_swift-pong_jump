//
//  ShopScene.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/19/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

class ShopScene : SCNScene, Mathable {
    
    private var pongBall:PongBall!
    private var cameraNode:SCNNode!
    
    override init() {
        super.init()
        
        background.contents = UIColor.lightGray
        physicsWorld.gravity = SCNVector3(0, 0, 0)
        
        cameraNode = SCNNode()
        let camera:SCNCamera = SCNCamera()
        cameraNode.camera = camera
        rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(0, 0, 0)
        cameraNode.eulerAngles = SCNVector3(toRadians(floatDegree: -10), 0, 0)
        
        pongBall = PongBall(texture: PongBallTexture(copy: gameSettings.getPongBallTexture()))
        pongBall.physicsBody = nil
        rootNode.addChildNode(pongBall)
        pongBall.position = SCNVector3(0, -1, -10)
        pongBall.runAction(SCNActions.PONG_BALL_ROTATION_HORIZONTAL_X)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getPongBallTexture() -> PongBallTexture {
        return pongBall.getTexture()
    }
    public func setPongBallTexture(_ pongBallTexture: PongBallTexture) {
        pongBall.setTexture(pongBallTexture)
    }
    
    private func getTextNode(text: String) -> SCNNode {
        let text:SCNText = SCNText(string: text, extrusionDepth: 0.50)
        text.font = text.font.withSize(1)
        return SCNNode(geometry: text)
    }
}
