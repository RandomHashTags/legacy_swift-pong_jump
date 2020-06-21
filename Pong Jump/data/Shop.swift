//
//  Shop.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/3/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation

class Shop {
    private var cachedCurrency:[PaddleType:Int]!
    private var ownedPongBallTextures:[PongBallTexture]!
    
    init() {
        load()
    }
    
    public func load() {
        cachedCurrency = [PaddleType:Int]()
    }
    public func unload() {
        cachedCurrency.removeAll()
        ownedPongBallTextures.removeAll()
    }
    
    internal func save() {
        saveCurrencies()
        saveOwnedPongBallTextures()
    }
    private func saveCurrencies() {
        for currency in PaddleType.allCases {
            CONFIG.set(getCurrency(type: currency), forKey: getCurrencyKey(currency: currency))
        }
    }
    private func saveOwnedPongBallTextures() {
        var array:[String] = [String]()
        for texture in getOwnedPongBallTextures() {
            array.append(texture.getKey())
        }
        data.setConfigValue(.OWNED_PONG_BALL_TEXTURES, value: array)
    }
    
    public func getCurrency(type: PaddleType) -> Int {
        guard cachedCurrency[type] == nil else { return cachedCurrency[type]! }
        let key:String = getCurrencyKey(currency: type)
        let configValue:Int? = data.getConfigValue(key: key) as? Int
        let value:Int = configValue == nil ? 0 : configValue!
        cachedCurrency[type] = value
        return value
    }
    public func addCurrency(type: PaddleType, amount: Int) {
        let current:Int = getCurrency(type: type)
        let multiplier:Int = gameSettings.hasActiveAttribute(.DOUBLE_CURRENCY) ? 2 : 1
        cachedCurrency[type] = current+(multiplier * amount)
    }
    private func getCurrencyKey(currency: PaddleType) -> String {
        return DataValue.CURRENCY.rawValue + "." + currency.rawValue
    }
    
    private func getOwnedPongBallTextures() -> [PongBallTexture] {
        guard ownedPongBallTextures == nil else { return ownedPongBallTextures }
        ownedPongBallTextures = [PongBallTexture]()
        let array:[String] = data.getConfigValue(.OWNED_PONG_BALL_TEXTURES, defaultValue: ["default"]) as! [String]
        for texture in PongBallTexture.getAllCases() {
            if array.contains(texture.getKey()) {
                ownedPongBallTextures.append(texture)
            }
        }
        return ownedPongBallTextures
    }
    public func isOwned(pongBallTexture: PongBallTexture) -> Bool {
        return getOwnedPongBallTextures().contains(pongBallTexture)
    }
}

extension Shop {
    private func isBuyable(currency: Int, cost: Int) -> Bool {
        return currency >= cost
    }
    public func isBuyable(purchasable: Purchasable, currency: PaddleType) -> Bool {
        return !isActive(purchasable) && isBuyable(currency: getCurrency(type: currency), cost: purchasable.cost)
    }
    public func isBuyable(pongBallTexture: PongBallTexture, currency: PaddleType) -> Bool {
        return !isOwned(pongBallTexture: pongBallTexture) && isBuyable(currency: getCurrency(type: currency), cost: pongBallTexture.getCost())
    }
    
    public func purchase(purchasable: Purchasable, currency: PaddleType) {
        let cost:Int = purchasable.cost
        guard isBuyable(currency: getCurrency(type: currency), cost: cost) else { return }
        cachedCurrency[currency]! -= cost
        activate(purchasable)
    }
    public func purchase(pongBallTexture: PongBallTexture, currency: PaddleType) {
        guard isBuyable(pongBallTexture: pongBallTexture, currency: currency) else { return }
        cachedCurrency[currency]! -= pongBallTexture.getCost()
        ownedPongBallTextures.append(pongBallTexture)
    }
}

extension Shop {
    public func isActive(_ purchasable: Purchasable) -> Bool {
        switch purchasable {
        case .DOUBLE_CURRENCY: return gameSettings.hasActiveAttribute(.DOUBLE_CURRENCY)
        case .SECOND_CHANCE: return gameSettings.hasActiveAttribute(.SECOND_CHANCE)
        case .REMOVE_BANNER_ADS: return !advertisements.isShowingAds(.BANNER)
        case .REMOVE_INTERSTITIAL_ADS: return !advertisements.isShowingAds(.INTERSTITIAL)
        default: return false
        }
    }
    private func activate(_ purchasable: Purchasable) {
        switch purchasable {
        case .REMOVE_BANNER_ADS, .REMOVE_INTERSTITIAL_ADS:
            let isBanner:Bool = purchasable == .REMOVE_BANNER_ADS
            data.setConfigValue(isBanner ? .SHOW_BANNER_ADS : .SHOW_INTERSTITIAL_ADS, value: false)
            advertisements.stopShowingAds(isBanner ? .BANNER : .INTERSTITIAL)
            break
        default:
            gameSettings.setActiveAttribute(purchasable, true)
            break
        }
    }
}
