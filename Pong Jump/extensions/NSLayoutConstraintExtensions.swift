//
//  NSLayoutConstraintExtensions.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/14/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func animate(duration: TimeInterval, toConstant: CGFloat, viewHolder: UIView) {
        animate(duration: duration, toConstant: toConstant, viewHolder: viewHolder, completion: nil)
    }
    func animate(duration: TimeInterval, toConstant: CGFloat, viewHolder: UIView, completion: (() -> Void)?) {
        UIView.animate(withDuration: duration, animations: {
            self.constant = toConstant
            viewHolder.layoutIfNeeded()
        }) { (did) in
            completion?()
        }
    }
}
