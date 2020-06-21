//
//  RewardedAd.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/20/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class RewardedAd : GADRewardedAd, GADRewardedAdDelegate, Advertisement {
    private var onPresented:(() -> Void)?, onDismissed:(() -> Void)?, onFailedToShow:((Error) -> Void)?, onRewardObtained:((String, NSDecimalNumber) -> Void)?
    
    func load(onLoaded: (() -> Void)?, onFailedToLoad: ((Error) -> Void)?) {
        load(GADRequest()) { (error) in
            if let error = error {
                onFailedToLoad?(error)
            } else {
                onLoaded?()
            }
        }
    }
    func show(onPresented: (() -> Void)?, onDismissed: (() -> Void)?, onFailedToShow: ((Error) -> Void)?, onRewardObtained: ((String, NSDecimalNumber) -> Void)?) {
        if isReady {
            self.onPresented = onPresented
            self.onDismissed = onDismissed
            self.onFailedToShow = onFailedToShow
            self.onRewardObtained = onRewardObtained
            present(fromRootViewController: GAME_CONTROLLER, delegate: self)
        }
    }
}

extension RewardedAd {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("rewardedAdUserDidEarn")
        onRewardObtained?(reward.type, reward.amount)
    }
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("rewardedAdDidPresent")
        setGamePaused(true)
        onPresented?()
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("rewardedAdDidDismiss")
        setGamePaused(false)
        onDismissed?()
    }
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("rewardedAdDidFailtToPresentWithError=" + error.localizedDescription)
        onFailedToShow?(error)
    }
}
