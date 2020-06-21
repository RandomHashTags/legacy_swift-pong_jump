//
//  GestureRecognizers.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/28/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

protocol GestureRecognizers {
}
extension GestureRecognizers {
    func getSwipeGesture(target: Any?, action: Selector?, direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let gesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: target, action: action)
        gesture.direction = direction
        gesture.numberOfTouchesRequired = 1
        return gesture
    }
    func getTapGesture(target: Any?, action: Selector?, numberOfTapsRequired: Int, numberOfTouchesRequired: Int) -> UITapGestureRecognizer {
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        gesture.numberOfTapsRequired = numberOfTapsRequired
        gesture.numberOfTouchesRequired = numberOfTouchesRequired
        return gesture
    }
}
