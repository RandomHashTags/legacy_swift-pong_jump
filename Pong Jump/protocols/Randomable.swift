//
//  Randomable.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/28/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

protocol Randomable {
}
extension Randomable {
    
    private func getRandomDouble() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    public func getRandomNumber(min: Int, max: Int) -> Int {
        return min+Int(arc4random_uniform(UInt32(max-min+1)))
    }
    public func getRandomNumber(min: Double, max: Double) -> Double {
        return min+getRandomDouble()*(max-min+1)
    }
    
    public func getRandomUIColor(_ colors: [UIColor]) -> UIColor {
        let randomIndex:Int = getRandomNumber(min: 0, max: colors.count-1)
        return colors[randomIndex]
    }
    public func getColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    public func getRandomUIColor() -> UIColor {
        let red:CGFloat = CGFloat(getRandomNumber(min: 0, max: 255))
        let green:CGFloat = CGFloat(getRandomNumber(min: 0, max: 255))
        let blue:CGFloat = CGFloat(getRandomNumber(min: 0, max: 255))
        return getColor(red, green, blue, 1.00)
    }
}
