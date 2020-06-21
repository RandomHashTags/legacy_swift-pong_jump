//
//  SCNAudioSourceExtensions.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/19/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

extension SCNAudioSource {
    func with(volume: Float) -> SCNAudioSource {
        self.volume = volume
        return self
    }
}
