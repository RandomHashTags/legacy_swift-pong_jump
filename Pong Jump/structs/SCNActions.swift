//
//  SCNActions.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/2/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

struct SCNActions {
    static var PONG_PLATFORM_MOVE_Y:SCNAction = SCNAction.moveBy(x: 0, y: 10, z: 0, duration: 1.00)
    static var PONG_BALL_BOUNCE_AUDIO:SCNAction = getPongBallSound(volume: 1.00)
    static var MOVE_Z:SCNAction = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0, z: -10, duration: 1.00))
    static var PADDLE_ROTATION:SCNAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 5, z: 0, duration: 1.00))
    static var CAMERA_MOVE_Y:SCNAction = SCNAction.move(by: SCNVector3(0, 50, 0), duration: 0.50)
    static var PONG_BALL_ROTATION_VERTICAL:SCNAction = SCNAction.repeatForever(SCNAction.rotateBy(x: -20, y: 0, z: 0, duration: 1.00))
    static var PONG_BALL_ROTATION_HORIZONTAL_Z:SCNAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: -1, duration: 1.00))
    static var PONG_BALL_ROTATION_HORIZONTAL_X:SCNAction = SCNAction.repeatForever(SCNAction.rotateBy(x: -1, y: 0, z: 0, duration: 1.00))
    
    public static func getPongBallSound(volume: Float) -> SCNAction {
        return SCNAction.playAudio(Sounds.PONG_BALL_BOUNCE.getSound(volume: volume), waitForCompletion: false)
    }
}
