//
//  Purchasables.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/14/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation

struct Purchasable : Equatable {
    var key:String, cost:Int
}

extension Purchasable {
    static var SECOND_CHANCE:Purchasable = Purchasable(key: "second chance", cost: 100)
    static var DOUBLE_CURRENCY:Purchasable = Purchasable(key: "double currency", cost: 10000)
    static var REMOVE_BANNER_ADS:Purchasable = Purchasable(key: "remove banner ads", cost: 25000)
    static var REMOVE_INTERSTITIAL_ADS:Purchasable = Purchasable(key: "remove interstitial ads", cost: 50000)
}
