//
//  GameSettings.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/1/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation

class GameSettings {
    private var pongBallTexture:PongBallTexture!
    private var activeAttributes:[GameAttribute]
    
    private var statuses:[GameStatus:Bool]!
    
    init() {
        statuses = [GameStatus:Bool]()
        pongBallTexture = PongBallTexture.SPHERE
        activeAttributes = [GameAttribute]()
    }
    
    public func getPongBallTexture() -> PongBallTexture {
        return pongBallTexture
    }
    public func setPongBallTexture(_ pongBallTexture: PongBallTexture) {
        self.pongBallTexture = pongBallTexture
        GAME_CONTROLLER.pongBall.setTexture(pongBallTexture)
    }
    
    public func getActiveAttributes() -> [GameAttribute] {
        return activeAttributes
    }
    public func hasActiveAttribute(_ gameAttribute: GameAttribute) -> Bool {
        return activeAttributes.contains(gameAttribute)
    }
    public func setActiveAttribute(_ purchasable: Purchasable, _ value: Bool) {
        setActiveAttribute(convertPurchasable(purchasable), value)
    }
    private func convertPurchasable(_ purchasable: Purchasable) -> GameAttribute! {
        switch purchasable {
        case .DOUBLE_CURRENCY: return .DOUBLE_CURRENCY
        case .SECOND_CHANCE: return .SECOND_CHANCE
        default: return nil
        }
    }
    public func setActiveAttribute(_ gameAttribute: GameAttribute, _ value: Bool) {
        if !value {
            activeAttributes = activeAttributes.filter() { $0 != gameAttribute }
        } else if value && !activeAttributes.contains(gameAttribute) {
            activeAttributes.append(gameAttribute)
        }
    }
    
    public func resetGameStatus() {
        for status in GameStatus.allCases {
            statuses[status] = false
        }
        activeAttributes = activeAttributes.filter() { $0 != .SECOND_CHANCE }
    }
    public func isGameStatus(_ gameStatus: GameStatus) -> Bool {
        return statuses[gameStatus]!
    }
    public func setGameStatus(_ gameStatus: GameStatus, _ value: Bool) {
        statuses[gameStatus] = value
    }
}
