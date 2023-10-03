//
//  Item.swift
//  saga
//
//  Created by Christian McCartney on 1/1/22.
//

import SpriteKit

struct Item {
    let id: UUID
    let name: String
    let type: ItemType
    
    public init(id: UUID = UUID(), name: String, type: ItemType) {
        self.id = id
        self.name = name
        self.type = type
    }
}

extension Item: Hashable {}
extension Item: Identifiable {}
