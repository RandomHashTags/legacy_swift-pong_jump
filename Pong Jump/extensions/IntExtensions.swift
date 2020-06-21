//
//  IntExtensions.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/10/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation

extension Int {
    func formatUsingCommas() -> String {
        let formatter:NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))!
    }
}
