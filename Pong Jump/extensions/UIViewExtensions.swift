//
//  UIViewExtensions.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/9/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func shakeScreen(from: CGPoint, to: CGPoint, repeatCount: Float, duration: CFTimeInterval) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        
        animation.fromValue = from.add(point: center)
        animation.toValue = to.add(point: center)
        layer.add(animation, forKey: "position")
    }
}
