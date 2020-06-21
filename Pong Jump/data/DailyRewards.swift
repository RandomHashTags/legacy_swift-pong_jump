//
//  DailyRewards.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/17/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation

class DailyRewards {
    
    public func check() {
        let calendar:Calendar = Calendar.current
        let today:Date = Date()
        
        let lastPlayed:Date? = data.getConfigValue(.DAILY_REWARD_LAST_PLAYED, defaultValue: nil) as? Date
        var streak:Int = data.getConfigValue(.DAILY_REWARD_STREAK, defaultValue: 0) as! Int
        if lastPlayed == nil {
            print("last played == nil!")
            activate(streak: 0)
        } else {
            let lastPlayedIsToday:Bool = calendar.isDateInToday(lastPlayed!)
            let lastPlayedWasYesterday:Bool = calendar.isDateInYesterday(lastPlayed!)
            print("isToday=" + lastPlayedIsToday.description)
            print("wasYesterday=" + lastPlayedWasYesterday.description)
            if lastPlayedIsToday {
                print("is TODAY, doesn't count!")
                return
            } else if lastPlayedWasYesterday {
                print("successfully collected daily reward!")
                streak += 1
                activate(streak: streak)
            } else {
                print("missed a daily reward, reset to zero!")
                streak = 0
            }
        }
        setLastPlayed(today: today, streak: streak)
        data.save()
    }
    
    private func setLastPlayed(today: Date, streak: Int) {
        data.setConfigValue(.DAILY_REWARD_LAST_PLAYED, value: today)
        data.setConfigValue(.DAILY_REWARD_STREAK, value: streak)
    }
    
    public func getDailyReward(streak: Int) -> Int {
        return streak == 0 ? 50 : streak == 1 ? 100 : 25*(5*streak)
    }
    
    private func activate(streak: Int) {
        let amount:Int = getDailyReward(streak: streak)
        print("previous BOX currency amount=" + shop.getCurrency(type: .BOX).description)
        print("added " + amount.description + " BOX currency!")
        shop.addCurrency(type: .BOX, amount: amount)
    }
    
}
