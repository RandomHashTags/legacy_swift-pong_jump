//
//  SCNVector3Extensions.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/28/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    func add(x: Float, y: Float, z: Float) -> SCNVector3 {
        return SCNVector3(self.x+x, self.y+y, self.z+z)
    }
    func add(vector3: SCNVector3) -> SCNVector3 {
        return add(x: vector3.x, y: vector3.y, z: vector3.z)
    }
    
    func with(x: Float) -> SCNVector3 {
        return SCNVector3(x, self.y, self.z)
    }
    func with(y: Float) -> SCNVector3 {
        return SCNVector3(self.x, y, self.z)
    }
    func with(z: Float) -> SCNVector3 {
        return SCNVector3(self.x, self.y, z)
    }
}
