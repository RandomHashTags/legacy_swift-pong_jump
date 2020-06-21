//
//  Advertisements.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/17/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class Advertisements : NSObject, ConstraintsAPI {
    private var showsAds:[AdType:Bool]!
    
    private var bannerAds:[BannerAdType:GADBannerView]!
    private var interstitialAds:[InterstitialAdType:GADInterstitial]!
    private var rewardedAds:[RewardedAdType:RewardedAd]!
    
    public func tryLoading() {
        showsAds = [AdType:Bool]()
        
        showsAds[.BANNER] = data.getConfigValue(.SHOW_BANNER_ADS, defaultValue: true) as? Bool
        if showsAds[.BANNER]! {
            bannerAds = [BannerAdType:GADBannerView]()
            showBannerAds()
        }
        
        showsAds[.INTERSTITIAL] = data.getConfigValue(.SHOW_INTERSTITIAL_ADS, defaultValue: true) as? Bool
        if showsAds[.INTERSTITIAL]! {
            interstitialAds = [InterstitialAdType:GADInterstitial]()
            loadInterstitialAd(type: .TEST)
        }
        
        rewardedAds = [RewardedAdType:RewardedAd]()
        loadRewardedAd(type: .TEST)
    }
    
    public func isShowingAds(_ adType: AdType) -> Bool {
        return showsAds[adType]!
    }
    
    public func stopShowingAds(_ adType: AdType) {
        showsAds[adType] = false
        
        switch adType {
        case .BANNER:
            for bannerAd in bannerAds.values {
                bannerAd.removeFromSuperview()
            }
            bannerAds = nil
            break
        case .INTERSTITIAL:
            interstitialAds = nil
            break
        default:
            break
        }
    }
    
    private func showBannerAds() {
        showBannerAd(type: .TEST)
    }
    private func showBannerAd(type: BannerAdType) {
        guard bannerAds[type] == nil else { return }
        
        let view:UIView = GAME_CONTROLLER.view
        
        let bannerAd:GADBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerAd.adUnitID = type.rawValue
        bannerAd.delegate = self
        bannerAd.rootViewController = GAME_CONTROLLER
        bannerAd.translatesAutoresizingMaskIntoConstraints = false
        bannerAd.backgroundColor = .clear
        view.addSubview(bannerAd)
        view.addConstraints([
            getConstraint(item: bannerAd, .bottom, toItem: view),
            getConstraint(item: bannerAd, .centerX, toItem: view)
        ])
        bannerAd.load(GADRequest())
        bannerAds[type] = bannerAd
    }
    
    private func loadInterstitialAd(type: InterstitialAdType) {
        let interstitial:GADInterstitial = GADInterstitial(adUnitID: type.rawValue)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        interstitialAds[type] = interstitial
    }
    internal func showInterstitialAd(type: InterstitialAdType) {
        if interstitialAds[type]!.isReady {
            interstitialAds[type]!.present(fromRootViewController: GAME_CONTROLLER)
        } else {
            print("interstitial ad wasn't ready")
        }
    }
    
    private func loadRewardedAd(type: RewardedAdType) {
        let rewardedAd:RewardedAd = RewardedAd(adUnitID: type.rawValue)
        rewardedAds[type] = rewardedAd
        rewardedAd.load(onLoaded: {
            print("successfully loaded reward ad!")
        }, onFailedToLoad: { (error) in
            print("failed to load reward ad!=" + error.localizedDescription)
        })
    }
    internal func showRewardedAd(type: RewardedAdType, onPresented: (() -> Void)?, onDismissed: (() -> Void)?, onFailedToShow: ((Error) -> Void)?, onRewardObtained: ((String, NSDecimalNumber) -> Void)?) {
        let ad:RewardedAd = rewardedAds[type]!
        let adUnitID:String = ad.adUnitID
        ad.show(onPresented: {
            print("successfully presented reward ad!")
            onPresented?()
        }, onDismissed: {
            onDismissed?()
            let newRewardedAd:RewardedAd = RewardedAd(adUnitID: adUnitID)
            self.rewardedAds[type] = newRewardedAd
            newRewardedAd.load(onLoaded: nil, onFailedToLoad: nil)
        }, onFailedToShow: { (error) in
            print("failed to show rewarded ad!")
            onFailedToShow?(error)
        }, onRewardObtained: { (reward, amount) in
            print("reward obtained=" + reward + " x" + amount.description)
            onRewardObtained?(reward, amount)
        })
    }
    
    private func setGamePaused(_ paused: Bool) {
        GAME_CONTROLLER.scene.isPaused = paused
    }
}

enum AdType : String {
    case BANNER = "banner"
    case INTERSTITIAL = "interstitial"
    case REWARDED = "rewarded"
}
enum BannerAdType : String {
    case TEST = "***REMOVED***"
    case BOTTOM_CENTER = "***REMOVED***"
}
enum InterstitialAdType : String {
    case TEST = "***REMOVED***"
    case EVERY_10_GAMES = "***REMOVED***"
}
enum RewardedAdType : String {
    case TEST = "***REMOVED***"
    case SECOND_CHANCE = "***REMOVED***"
    case MORE_CURRENCY = "***REMOVED***"
}

extension Advertisements : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adViewDidFailToReveiveAdWithError=" + error.description)
    }
}

extension Advertisements : GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        setGamePaused(false)
    }
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
        setGamePaused(true)
    }
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("interstitialDidFailToPresentScreen")
    }
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("internstitialDidFailToReceiveAdWithError=" + error.description)
    }
}
