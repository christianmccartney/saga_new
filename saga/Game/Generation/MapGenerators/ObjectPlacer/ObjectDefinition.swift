//
//  ObjectDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import Foundation

protocol ObjectDefinition {
    var id: UUID { get }
    var spawnChance: Int { get }

    var roomMax: Int { get }
    var mapMax: Int { get }
}

/// A `StaticObjectDefinition` describes an object and its spawn chance
public struct StaticObjectDefinition: ObjectDefinition {
    public let id: UUID
    /// The object type.
    let type: StaticObjectType
    /// Probability of spawning, 0 = never, 100 = always.
    let spawnChance: Int
    
    var roomMax: Int
    var mapMax: Int
    
    let walkable: Bool
    
    init(type: StaticObjectType, spawnChance: Int, roomMax: Int = -1, mapMax: Int = -1, walkable: Bool = false) {
        self.id = UUID()
        self.type = type
        self.spawnChance = spawnChance
        self.roomMax = roomMax
        self.mapMax = mapMax
        self.walkable = walkable
    }
}

public struct DynamicObjectDefinition: ObjectDefinition {
    public let id: UUID
    /// The object type.
    let type: DynamicObjectType
    /// Probability of spawning, 0 = never, 100 = always.
    let spawnChance: Int
    
    var roomMax: Int
    var mapMax: Int
    
    let walkable: Bool
    
    init(type: DynamicObjectType, spawnChance: Int, roomMax: Int = -1, mapMax: Int = -1, walkable: Bool = false) {
        self.id = UUID()
        self.type = type
        self.spawnChance = spawnChance
        self.roomMax = roomMax
        self.mapMax = mapMax
        self.walkable = walkable
    }
}

public struct ObjectLocation {
    let definitions: [ObjectDefinition]
    /// The locations that the object may spawn.
    let location: RoomLocation
    
    var definition: ObjectDefinition? {
        definitions.first { Int.random(in: 0..<100) < $0.spawnChance }
    }
    
    func entity(for definition: ObjectDefinition) -> Entity? {
        if let staticDef = definition as? StaticObjectDefinition {
            let object = StaticObject(type: staticDef.type)
            object.walkable = staticDef.walkable
            return object
        } else if let dynamicDef = definition as? DynamicObjectDefinition {
            let object = DynamicObject(type: dynamicDef.type)
            object.walkable = dynamicDef.walkable
            return object
        }
        return nil
    }

    init(definitions: [ObjectDefinition], location: RoomLocation) {
        self.definitions = definitions.sorted { $0.spawnChance < $1.spawnChance }
        self.location = location
    }
}
