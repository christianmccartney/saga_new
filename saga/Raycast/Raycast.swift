//
//  Raycast.swift
//  saga
//
//  Created by Christian McCartney on 12/4/21.
//

import Foundation
import SpriteKit

struct Ray {
    // Start point
    let o: CGPoint
    // Scalar (distance)
    let t: CGFloat
    // Direction
    let d: CGVector
}

class RayCaster {
    static let shared = RayCaster()
    
    private init() {}
    
    func intersects() {
        
        
    }
}
