//
//  Feedback.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/7/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

struct Feedback {
    internal static var PONG_BOX:UIImpactFeedbackGenerator = {
        let haptic:UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
        haptic.prepare()
        return haptic
    }()
    internal static var PONG_SPRING:UIImpactFeedbackGenerator = {
        let haptic:UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        haptic.prepare()
        return haptic
    }()
}
