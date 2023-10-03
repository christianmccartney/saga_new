//
//  RoomDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

enum AnyRoomDefinition {
    static let cobwebNE =   StaticObjectDefinition(type: StaticObjectType.web_ne, spawnChance: 50, walkable: true)
    static let cobwebNW =   StaticObjectDefinition(type: StaticObjectType.web_nw, spawnChance: 50, walkable: true)
    static let cobwebSE =   StaticObjectDefinition(type: StaticObjectType.web_se, spawnChance: 50, walkable: true)
    static let cobwebSW =   StaticObjectDefinition(type: StaticObjectType.web_sw, spawnChance: 50, walkable: true)
    
//    static let torch =  DynamicObjectDefinition(type: DynamicObjectType.torch_light, spawnChance: 30, roomMax: 1, mapMax: 3, walkable: true)
    
    static let cornerNE = ObjectLocation(
        definitions: [cobwebNE],
        location: .northEast(0, 0))
    static let cornerNW = ObjectLocation(
        definitions: [cobwebNW],
        location: .northWest(0, 0))
    static let cornerSE = ObjectLocation(
        definitions: [cobwebSE],
        location: .southEast(0, 0))
    static let cornerSW = ObjectLocation(
        definitions: [cobwebSW],
        location: .southWest(0, 0))
    
}
