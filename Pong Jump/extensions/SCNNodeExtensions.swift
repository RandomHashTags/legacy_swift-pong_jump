//
//  SCNNodeExtensions.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/29/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    func delete() {
        removeAllActions()
        removeAllAnimations()
        removeAllAudioPlayers()
        removeAllParticleSystems()
        removeFromParentNode()
    }
    func with(geometry: SCNGeometry?) -> SCNNode {
        self.geometry = geometry
        return self
    }
}
