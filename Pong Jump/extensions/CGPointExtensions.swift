//
//  CGPointExtensions.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/4/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    func add(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x+x, y: self.y+y)
    }
    func add(point: CGPoint) -> CGPoint {
        return add(x: point.x, y: point.y)
    }
}
