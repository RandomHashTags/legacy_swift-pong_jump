//
//  Sounds.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/4/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

struct Sounds {
    static var PONG_BALL_BOUNCE:Sound = Sound(fileNamed: "pongBallBounce.mp3", loops: false)
}

struct Sound {
    private var audioSource:SCNAudioSource!
    
    init(fileNamed: String, loops: Bool) {
        audioSource = SCNAudioSource(fileNamed: fileNamed)
        audioSource.loops = loops
    }
    
    func getSound(volume: Float) -> SCNAudioSource {
        return audioSource.with(volume: volume)
    }
}
