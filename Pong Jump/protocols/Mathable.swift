//
//  Mathable.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/30/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation

protocol Mathable {
}

extension Mathable {
    func toRadians(doubleDegree: Double) -> Double {
        return doubleDegree*Double.pi/180
    }
    func toRadians(floatDegree: Float) -> Float {
        return floatDegree*Float.pi/180
    }
}
