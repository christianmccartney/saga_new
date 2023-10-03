//
//  ItemType.swift
//  saga
//
//  Created by Christian McCartney on 1/1/22.
//

import SpriteKit

public enum ItemType: String, CaseIterable, EntityType {
    case amulet_gold
    case amulet_magic
    case amulet_silver
    case arrow
    case bandage
    case bolt
    case book_black
    case book_brown
    case book_green
    case caltrops
    case cape_leather
    case cape_magic
    case cape_purple
    case coins_copper
    case coins_gold
    case coins_silver
    case compass
    case cross
    case crown_evil
    case crown_gold
    case crown_silver
    case crystal_empty
    case crystal_full
    case darts
    case feather
    case flask_blue
    case flask_green
    case flask_red
    case gem_amethyst
    case gem_garnet
    case gem_jade
    case gem_ruby
    case gem_sapphire
    case hat_leather
    case hat_magic
    case hat_purple
    
    public var lightNode: SKLightNode? { nil }
    
    public var lightingCategory: UInt32 {
        return LightingCategory.all
    }
}
