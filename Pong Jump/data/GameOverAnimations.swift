//
//  GameOverAnimations.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/3/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

enum GameOverAnimation : Int { // Price to unlock
    case DEFAULT = 0
    case WORLD = 10
    case RECALL = 100
}

class GameOverAnimations {
    internal func getParticleSystem(geometry: SCNGeometry, _ animation: GameOverAnimation) -> SCNParticleSystem {
        let system:SCNParticleSystem = SCNParticleSystem()
        switch animation {
        case .DEFAULT:
            system.particleLifeSpanVariation = 2.00
            system.particleVelocity = 1.00
            system.particleAngleVariation = 3.00
            system.particleVelocityVariation = 25
            break
        case .WORLD:
            break
        case .RECALL:
            system.acceleration = SCNVector3(0, 90, 200)
            break
        default:
            break
        }
        
        system.blendMode = .alpha
        system.emissionDuration = getEmissionDuration(animation)
        system.birthRate = 500
        system.birthDirection = getBirthDirection(animation)
        system.birthLocation = getBirthLocation(animation)
        system.emittingDirection = SCNVector3(0, 0, 0)
        
        system.particleLifeSpan = 1.00
        system.particleSize = 0.10
        
        system.emitterShape = geometry
        system.particleColor = geometry.materials.first!.diffuse.contents as! UIColor
        system.loops = false
        
        let gravity:Bool = false//isAffectedByGravity(animation)
        system.isAffectedByGravity = gravity
        system.isAffectedByPhysicsFields = gravity
        system.particleDiesOnCollision = gravity
        return system
    }
    private func getBirthDirection(_ animation: GameOverAnimation) -> SCNParticleBirthDirection {
        switch animation {
        case .DEFAULT:
            return .random
        default:
            return .constant
        }
    }
    private func getBirthLocation(_ animation: GameOverAnimation) -> SCNParticleBirthLocation {
        switch animation {
        case .WORLD:
            return .vertex
        default:
            return .surface
        }
    }
    /*private func isAffectedByGravity(_ animation: GameOverAnimation) -> Bool {
        switch animation {
        case .DRIP:
            return true
        default:
            return false
        }
    }*/
    
    private func getEmissionDuration(_ animation: GameOverAnimation) -> CGFloat {
        switch animation {
        case .DEFAULT:
            return 0.25
        case .WORLD:
            return 0.50
        case .RECALL:
            return 0.75
        default:
            return 1.00
        }
    }
}
