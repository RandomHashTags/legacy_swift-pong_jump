//
//  UIViewPropertyAnimation.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/16/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

class UIViewPropertyAnimation : UIViewPropertyAnimator {
    
    private var undo:((CGFloat) -> Void)?
    
    convenience init(duration: TimeInterval, curve: UIView.AnimationCurve, animations: (() -> Void)? = nil, undo: ((CGFloat) -> Void)?) {
        self.init(duration: duration, curve: curve, animations: animations)
        self.undo = undo
    }
    
    public func undoAnimation() {
        stopAnimation(true)
        undo?(fractionComplete)
    }
}
