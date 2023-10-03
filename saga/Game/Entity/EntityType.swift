//
//  EntityType.swift
//  Saga
//
//  Created by Christian McCartney on 5/25/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

public protocol EntityType {
    var lightNode: SKLightNode? { get }
    var lightingCategory: UInt32 { get }
}

extension EntityType where Self: RawRepresentable, RawValue == String {
    var name: String {
        return self.rawValue
    }
}
