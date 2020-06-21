//
//  Advertisement.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/20/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation

protocol Advertisement {
}
extension Advertisement {
    func setGamePaused(_ paused: Bool) {
        GAME_CONTROLLER.scene.isPaused = paused
    }
}
