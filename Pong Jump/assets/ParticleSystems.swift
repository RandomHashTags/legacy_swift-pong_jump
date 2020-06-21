//
//  ParticleSystems.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/11/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

class ParticleSystems {
    private static var cache:[CustomParticleSystem:SCNParticleSystem] = [CustomParticleSystem:SCNParticleSystem]()
    
    public static func get(system: CustomParticleSystem, geometry: SCNGeometry?) -> SCNParticleSystem! {
        guard cache[system] == nil else {
            let copy:SCNParticleSystem = cache[system]!
            copy.emitterShape = system == .PADDLE_OBTAIN ? getCurrencyText() : geometry
            copy.particleColor = geometry?.materials.first!.diffuse.contents as! UIColor
            return copy
        }
        
        let particleSystem:SCNParticleSystem! = getParticleSystem(system, geometry)
        cache[system] = particleSystem
        return particleSystem
    }
    
    private static func getParticleSystem(_ system: CustomParticleSystem, _ geometry: SCNGeometry?) -> SCNParticleSystem! {
        switch system {
        case .PADDLE_OBTAIN:
            return SCNParticleSystemBuilder(values: [
                .GEOMETRY : getCurrencyText(),
                .BLEND_MODE : SCNParticleBlendMode.alpha,
                .EMISSION_DURATION : 0.10,
                .EMISSION_DIRECTION : SCNVector3(0, 0, 0),
                .BIRTH_RATE : 500,
                .BIRTH_DIRECTION : SCNParticleBirthDirection.random,
                .BIRTH_LOCATION : SCNParticleBirthLocation.surface,
                .PARTICLE_LIFE_SPAN : 0.75,
                .PARTICLE_LIFE_SPAN_VARIATION : 0.25,
                .PARTICLE_SIZE : 0.05,
                .PARTICLE_VELOCITY : 1.00,
                .PARTICLE_VELOCITY_VARIATION : 5
            ]).build()
        case .PONG_BALL_END_GAME:
            return SCNParticleSystemBuilder(values: [
                .GEOMETRY : geometry as Any,
                .BLEND_MODE : SCNParticleBlendMode.alpha,
                .EMISSION_DURATION : 0.25,
                .EMISSION_DIRECTION : SCNVector3(0, 0, 0),
                .BIRTH_RATE : 500,
                .BIRTH_DIRECTION : SCNParticleBirthDirection.random,
                .BIRTH_LOCATION : SCNParticleBirthLocation.surface,
                .PARTICLE_LIFE_SPAN : 1.00,
                .PARTICLE_LIFE_SPAN_VARIATION : 2.00,
                .PARTICLE_SIZE : 0.10,
                .PARTICLE_VELOCITY : 1.00,
                .PARTICLE_VELOCITY_VARIATION : 25,
                .PARTICLE_ANGLE_VARIATION : 3.00
            ]).build()
        default:
            return nil
        }
    }
    
    private static func getCurrencyText() -> SCNText {
        let text:SCNText = SCNText(string: shop.getCurrency(type: .BOX).description, extrusionDepth: 1)
        text.font = text.font.withSize(5)
        return text
    }
}

enum CustomParticleSystem {
    case PADDLE_OBTAIN
    case PONG_BALL_END_GAME
}

enum SCNParticleSetting {
    case GEOMETRY
    case ACCELERATION
    case BLEND_MODE
    case EMISSION_DURATION
    case EMISSION_DIRECTION
    case BIRTH_RATE
    case BIRTH_DIRECTION
    case BIRTH_LOCATION
    case PARTICLE_LIFE_SPAN
    case PARTICLE_LIFE_SPAN_VARIATION
    case PARTICLE_SIZE
    case PARTICLE_VELOCITY
    case PARTICLE_VELOCITY_VARIATION
    case PARTICLE_ANGLE_VARIATION
}

struct SCNParticleSystemBuilder {
    private var values:[SCNParticleSetting:Any]!
    
    init() {
        values = [SCNParticleSetting:Any]()
    }
    init(values: [SCNParticleSetting:Any]) {
        self.values = values
    }
    
    mutating func with(_ setting: SCNParticleSetting, _ value: Any?) {
        values[setting] = value
    }
    
    func build() -> SCNParticleSystem {
        return getParticleSystem(
            geometry: getValue(.GEOMETRY) as? SCNGeometry,
            acceleration: getValue(.ACCELERATION) as? SCNVector3,
            blendMode: getValue(.BLEND_MODE) as? SCNParticleBlendMode,
            emissionDuration: getNumber(.EMISSION_DURATION) as? CGFloat,
            emissionDirection: getValue(.EMISSION_DIRECTION) as? SCNVector3,
            birthRate: getNumber(.BIRTH_RATE) as? CGFloat,
            birthDirection: getValue(.BIRTH_DIRECTION) as? SCNParticleBirthDirection,
            birthLocation: getValue(.BIRTH_LOCATION) as? SCNParticleBirthLocation,
            particleLifeSpan: getNumber(.PARTICLE_LIFE_SPAN) as? CGFloat,
            particleLifeSpanVariation: getNumber(.PARTICLE_LIFE_SPAN_VARIATION) as? CGFloat,
            particleSize: getNumber(.PARTICLE_SIZE) as? CGFloat,
            particleAngleVariation: getNumber(.PARTICLE_ANGLE_VARIATION) as? CGFloat,
            particleVelocity: getNumber(.PARTICLE_VELOCITY) as? CGFloat,
            particleVelocityVariation: getNumber(.PARTICLE_VELOCITY_VARIATION) as? CGFloat
        )
    }
    
    func getValue(_ setting: SCNParticleSetting) -> Any? {
        return values[setting]
    }
    func getNumber(_ setting: SCNParticleSetting) -> NSNumber? {
        return values[setting] as? NSNumber
    }
    
    private func getParticleSystem(geometry: SCNGeometry?,
                                      acceleration: SCNVector3?,
                                      blendMode: SCNParticleBlendMode?,
                                      emissionDuration: CGFloat?,
                                      emissionDirection: SCNVector3?,
                                      birthRate: CGFloat?,
                                      birthDirection: SCNParticleBirthDirection?,
                                      birthLocation: SCNParticleBirthLocation?,
                                      particleLifeSpan: CGFloat?,
                                      particleLifeSpanVariation: CGFloat?,
                                      particleSize: CGFloat?,
                                      particleAngleVariation: CGFloat?,
                                      particleVelocity: CGFloat?,
                                      particleVelocityVariation: CGFloat?
    ) -> SCNParticleSystem {
        let system:SCNParticleSystem = SCNParticleSystem()
        if acceleration != nil {
            system.acceleration = acceleration!
        }
        if blendMode != nil {
            system.blendMode = blendMode!
        }
        
        if emissionDuration != nil {
            system.emissionDuration = emissionDuration!
        }
        if emissionDirection != nil {
            system.emittingDirection = emissionDirection!
        }
        
        if birthRate != nil {
            system.birthRate = birthRate!
        }
        if birthDirection != nil {
            system.birthDirection = birthDirection!
        }
        if birthLocation != nil {
            system.birthLocation = birthLocation!
        }
                
        if particleLifeSpan != nil {
            system.particleLifeSpan = particleLifeSpan!
        }
        if particleLifeSpanVariation != nil {
            system.particleLifeSpanVariation = particleLifeSpanVariation!
        }
        if particleSize != nil {
            system.particleSize = particleSize!
        }
        if particleVelocity != nil {
            system.particleLifeSpanVariation = particleLifeSpanVariation!
        }
        if particleVelocityVariation != nil {
            system.particleVelocityVariation = particleVelocityVariation!
        }
        if particleAngleVariation != nil {
            system.particleAngleVariation = particleAngleVariation!
        }
        
        system.emitterShape = geometry
        system.particleColor = geometry?.materials.first!.diffuse.contents as! UIColor
        system.loops = false
        
        let gravity:Bool = false
        system.isAffectedByGravity = gravity
        system.isAffectedByPhysicsFields = gravity
        system.particleDiesOnCollision = gravity
        return system
    }
}
