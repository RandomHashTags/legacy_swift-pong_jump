//
//  PongBallTexture.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/18/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

struct PongBallTexture : Equatable, Randomable, Mathable {
    static func == (lhs: PongBallTexture, rhs: PongBallTexture) -> Bool {
        return lhs.key == rhs.key
    }
    
    private static var usableShapes:[PongBallTexture] = [PongBallTexture](), usableColors:[PongBallTexture] = [PongBallTexture]()
    
    private var geometry:SCNGeometry!, color:Any!
    private var key:String, name: String, eulerAngle:EulerAngle!, cost:Int
    
    init(copy: PongBallTexture) {
        self.init(key: copy.key, name: copy.name, geometry: copy.geometry, color: copy.color, eulerAngle: copy.eulerAngle, cost: copy.cost, append: false)
    }
    init(key: String, name: String, cost: Int) {
        self.init(key: key, name: name, color: nil, cost: cost)
    }
    init(key: String, name: String, color: Any?, cost: Int) {
        self.init(key: key, name: name, geometry: nil, color: color, cost: cost)
    }
    init(key: String, name: String, geometry: SCNGeometry?, color: Any?, cost: Int) {
        self.init(key: key, name: name, geometry: geometry, color: color, eulerAngle: .DEFAULT, cost: cost)
    }
    fileprivate init(key: String, name: String, geometry: SCNGeometry?, color: Any?, eulerAngle: EulerAngle, cost: Int) {
        self.init(key: key, name: name, geometry: geometry, color: color, eulerAngle: eulerAngle, cost: cost, append: true)
    }
    fileprivate init(key: String, name: String, geometry: SCNGeometry?, color: Any?, eulerAngle: EulerAngle, cost: Int, append: Bool) {
        self.key = key
        self.name = name
        self.geometry = geometry
        self.color = color
        self.cost = cost
        self.eulerAngle = eulerAngle
        if geometry != nil {
            PongBallTexture.usableShapes.append(self)
        } else if color != nil {
            PongBallTexture.usableColors.append(self)
        }
    }
    
    func getKey() -> String {
        return key
    }
    func getName() -> String {
        return name
    }
    func getValue() -> NSObject? {
        switch self {
        case .RANDOM: return getRandomTexture().getValue()
        case .COLOR_RANDOM: return getRandomUIColor()
        default: return nil
        }
    }
    
    mutating func setGeometry(_ geometry: SCNGeometry) {
        self.geometry = geometry
    }
    mutating func setColor(_ color: Any!) {
        self.color = color
    }
    
    func getGeometry() -> SCNGeometry! {
        return geometry
    }
    func getColor() -> Any! {
        return color
    }
    func getEulerAngles() -> SCNVector3! {
        switch eulerAngle {
        case .NINETY: return SCNVector3(toRadians(floatDegree: 90), 0, 0)
        default: return nil
        }
    }
    func getCost() -> Int {
        return cost
    }
    
    private func getRandomTexture() -> PongBallTexture {
        let textures:[PongBallTexture] = PongBallTexture.usableColors
        let texture:PongBallTexture = textures[getRandomNumber(min: 0, max: textures.count-1)]
        return texture
    }
}

extension PongBallTexture {
    internal static func getAllCases() -> [PongBallTexture] {
        return [
            .RANDOM,
        ]
    }
    
    internal static func getGeometry() -> [PongBallTexture] {
        return [
            .SPHERE,
            .TORUS,
            .BOX,
        ]
    }
    
    internal static func getColors() -> [PongBallTexture] {
        return [
            .COLOR_ADAPTIVE,
            .COLOR_RANDOM,
            .COLOR_BLACK,
            .COLOR_BLUE,
            .COLOR_BROWN,
            .COLOR_CYAN,
            .COLOR_GREEN,
            .COLOR_PURPLE,
            .COLOR_RED,
            .COLOR_MAGENTA,
            .COLOR_WHITE,
            .COLOR_YELLOW
        ]
    }
    
    static var RANDOM:PongBallTexture = PongBallTexture(key: "random", name: "Random", cost: 2000)
    
    static var SPHERE:PongBallTexture = PongBallTexture(key: "default", name: "Sphere", geometry: SCNSphere(radius: 1.5), color: UIColor.orange, cost: 0)
    static var TORUS:PongBallTexture = PongBallTexture(key: "shape.torus", name: "Torus", geometry: SCNTorus(ringRadius: 1.5, pipeRadius: 0.5), color: UIColor.magenta, eulerAngle: .NINETY, cost: 3000)
    static var BOX:PongBallTexture = PongBallTexture(key: "shape.box", name: "Box", geometry: SCNBox(width: 3, height: 3, length: 3, chamferRadius: 0), color: UIColor.green, cost: 3000)
    
    static var COLOR_ADAPTIVE:PongBallTexture = PongBallTexture(key: "color.adaptive", name: "Adaptive", color: UIColor.opaqueSeparator, cost: 1000)
    static var COLOR_RANDOM:PongBallTexture = PongBallTexture(key: "color.random", name: "Random Color", color: nil, cost: 1000)
    
    static var COLOR_BLACK:PongBallTexture = PongBallTexture(key: "color.black", name: "Black", color: UIColor.black, cost: 500)
    static var COLOR_BLUE:PongBallTexture = PongBallTexture(key: "color.blue", name: "Blue", color: UIColor.blue, cost: 500)
    static var COLOR_BROWN:PongBallTexture = PongBallTexture(key: "color.brown", name: "Brown", color: UIColor.brown, cost: 500)
    static var COLOR_CYAN:PongBallTexture = PongBallTexture(key: "color.cyan", name: "Cyan", color: UIColor.cyan, cost: 500)
    static var COLOR_GREEN:PongBallTexture = PongBallTexture(key: "color.green", name: "Green", color: UIColor.green, cost: 500)
    static var COLOR_PURPLE:PongBallTexture = PongBallTexture(key: "color.purple", name: "Purple", color: UIColor.purple, cost: 500)
    static var COLOR_RED:PongBallTexture = PongBallTexture(key: "color.red", name: "Red", color: UIColor.red, cost: 500)
    static var COLOR_MAGENTA:PongBallTexture = PongBallTexture(key: "color.magenta", name: "Magenta", color: UIColor.magenta, cost: 500)
    static var COLOR_WHITE:PongBallTexture = PongBallTexture(key: "color.white", name: "White", color: UIColor.white, cost: 500)
    static var COLOR_YELLOW:PongBallTexture = PongBallTexture(key: "color.yellow", name: "Yellow", color: UIColor.yellow, cost: 500)
}

private enum EulerAngle {
    case DEFAULT
    case NINETY
}
