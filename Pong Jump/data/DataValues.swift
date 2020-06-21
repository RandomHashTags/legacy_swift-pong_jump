//
//  DataValues.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/29/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

var CONFIG:UserDefaults = UserDefaults.standard

class DataValues : ConstraintsAPI {
    
    private var cachedValues:[DataValue:Int]!
    private var averageScore:Double!, allScores:[Int]!
    
    init() {
        cachedValues = [DataValue:Int]()
        recalculateAverageScore()
    }
    
    internal func getConfigValue(key: String) -> Any? {
        return CONFIG.value(forKey: key)
    }
    internal func getConfigValue(key: String, defaultValue: Any?) -> Any? {
        let configValue:Any? = CONFIG.value(forKey: key)
        return configValue != nil ? configValue : defaultValue
    }
    internal func getConfigValue(_ dataValue: DataValue, defaultValue: Any?) -> Any? {
        return getConfigValue(key: dataValue.rawValue, defaultValue: defaultValue)
    }
    
    public func save() {
        let values:[DataValue] = [.BEST_SCORE]
        for dataValue in values {
            CONFIG.set(getCacheValue(dataValue: dataValue), forKey: dataValue.rawValue)
        }
        CONFIG.set(getAllScores(), forKey: DataValue.ALL_SCORES.rawValue)
        shop.save()
        CONFIG.synchronize()
    }
    
    public func unload() {
        cachedValues.removeAll()
        allScores.removeAll()
    }
    
    public func getCacheValue(dataValue: DataValue) -> Int {
        guard cachedValues[dataValue] == nil else { return cachedValues[dataValue]! }
        let configValue:Int? = getConfigValue(key: dataValue.rawValue) as? Int
        let value:Int = configValue == nil ? 0 : configValue!
        cachedValues[dataValue] = value
        return value
    }
    public func setCacheValue(dataValue: DataValue, value: Int) {
        cachedValues[dataValue] = value
    }
    
    public func setConfigValue(_ dataValue: DataValue, value: Any?) {
        setConfigValue(key: dataValue.rawValue, value: value)
    }
    private func setConfigValue(key: String, value: Any?) {
        CONFIG.set(value, forKey: key)
    }
}

extension DataValues {
    public func getAllScores() -> [Int] {
        guard allScores == nil else { return allScores }
        let configValue:[Int] = getConfigValue(.ALL_SCORES, defaultValue: [Int]()) as! [Int]
        allScores = configValue
        return configValue
    }
    public func didScore(score: Int) {
        allScores.append(score)
        recalculateAverageScore()
    }
    private func recalculateAverageScore() {
        var average:Double = 0.00
        for score in getAllScores() {
            average += Double(score)
        }
        let size:Int = allScores.count
        averageScore = average/Double(size == 0 ? 1 : size)
    }
    public func getAverageScore() -> Double {
        return averageScore
    }
}

enum DataValue : String {
    case ALL_SCORES = "scoreboard.all scores"
    case BEST_SCORE = "scoreboard.best score"
    case CURRENCY = "data.currency"
    case SHOW_BANNER_ADS = "shop.show banner ads"
    case SHOW_INTERSTITIAL_ADS = "shop.show interstitial ads"
    case OWNED_PONG_BALL_TEXTURES = "shop.owned pong ball textures"
    case DAILY_REWARD_LAST_PLAYED = "stats.daily reward.last played"
    case DAILY_REWARD_STREAK = "stats.daily reward.streak"
}
