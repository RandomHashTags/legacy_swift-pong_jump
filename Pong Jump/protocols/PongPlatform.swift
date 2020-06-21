//
//  PongPlatform.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/2/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

protocol PongPlatform : SCNNode {
}
extension PongPlatform {
    public func dismiss() {
        physicsBody = nil
        
        let action:SCNAction = SCNAction.fadeOut(duration: 0.5)
        runAction(action) {
            self.delete()
        }
        let connector:PongBoxConnector? = GAME_CONTROLLER.pongBoxConnectors.first
        if connector != nil {
            connector!.dismiss(action)
        }
    }
}
