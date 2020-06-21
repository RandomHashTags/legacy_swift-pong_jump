//
//  PongBoxConnector.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/29/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

class PongBoxConnector : Mathable {
    
    private var out:SCNNode!, run:SCNNode?, up:SCNNode?
    private var xDistance:Float!, zDistance:Float!
    private var movedPositively:Bool!
    
    init(startsAt: SCNVector3, endsAt: SCNVector3) {
        let zDistance:Float = sqrtf(powf(endsAt.z-startsAt.z, 2))+0.5
        self.zDistance = zDistance
        let color:UIColor = UIColor.white
        
        let outGeometry:SCNBox = SCNBox(width: 0.5, height: 0.5, length: CGFloat(zDistance), chamferRadius: 1)
        outGeometry.materials.first!.diffuse.contents = color
        out = SCNNode(geometry: outGeometry)
        
        let startingX:Float = startsAt.x, endingX:Float = endsAt.x
        let maxX:Float = max(startingX, endingX), minX:Float = min(startingX, endingX)
        let xDistance:Float = maxX-minX
        self.xDistance = xDistance
        movedPositively = startingX < endingX
        if xDistance > 0 {
            let runGeometry:SCNBox = SCNBox(width: CGFloat(xDistance+0.5), height: 0.5, length: 0.5, chamferRadius: 1)
            runGeometry.materials.first!.diffuse.contents = color
            run = SCNNode(geometry: runGeometry)
        }
        
        let startsAtY:Float = startsAt.y, endsAtY:Float = endsAt.y
        if startsAtY != endsAtY {
            let upGeometry:SCNBox = SCNBox(width: 0.5, height: CGFloat(endsAtY-startsAtY), length: 0.5, chamferRadius: 0)
            upGeometry.materials.first!.diffuse.contents = color
            up = SCNNode(geometry: upGeometry)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func delete() {
        out.delete()
        GAME_CONTROLLER.pongBoxConnectors.removeFirst()
        if run != nil {
            run!.delete()
        }
        if up != nil {
            up!.delete()
        }
    }
    
    public func getOutNode() -> SCNNode {
        return out
    }
    public func getRunNode() -> SCNNode? {
        return run
    }
    public func getUpNode() -> SCNNode? {
        return up
    }
    public func getRunDistanceX() -> Float {
        return xDistance
    }
    public func getRunDistanceZ() -> Float {
        return zDistance
    }
    public func didMovePositively() -> Bool {
        return movedPositively
    }
    public func dismiss(_ action: SCNAction) {
        out.runAction(action) {
            self.out.delete()
            GAME_CONTROLLER.pongBoxConnectors.removeFirst()
        }
        if run != nil {
            run!.runAction(action) {
                self.run!.delete()
            }
        }
        if up != nil {
            up!.runAction(action) {
                self.up!.delete()
            }
        }
    }
}
