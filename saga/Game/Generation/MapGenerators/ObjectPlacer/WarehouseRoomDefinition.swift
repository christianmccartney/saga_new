//
//  WarehouseRoomDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

enum WarehouseRoomDefinition {
    private static let crate =          StaticObjectDefinition(type: .crate, spawnChance: 75)
    private static let brokenCrate =    StaticObjectDefinition(type: .crate_broken, spawnChance: 100)
    private static let centerCrate =    StaticObjectDefinition(type: .crate, spawnChance: 20)
    private static let centerCrateB =   StaticObjectDefinition(type: .crate_broken, spawnChance: 20)
    
    private static let urna =           StaticObjectDefinition(type: .urns_a, spawnChance: 25)
    private static let urnb =           StaticObjectDefinition(type: .urns_b, spawnChance: 50)
    private static let urnc =           StaticObjectDefinition(type: .urns_c, spawnChance: 75)
    private static let urnaCenter =     StaticObjectDefinition(type: .urns_a, spawnChance: 10)
    private static let urnbCenter =     StaticObjectDefinition(type: .urns_b, spawnChance: 10)
    private static let urncCenter =     StaticObjectDefinition(type: .urns_c, spawnChance: 10)
    
    private static let centerCrates =   ObjectLocation(definitions: [centerCrate, centerCrateB],
                                                       location: .center(0, 0))
    private static let northCrates =    ObjectLocation(definitions: [crate, brokenCrate], location: .north(0))
    private static let southCrates =    ObjectLocation(definitions: [crate, brokenCrate], location: .south(0))
    private static let eastCrates =     ObjectLocation(definitions: [crate, brokenCrate], location: .east(0))
    private static let westCrates =     ObjectLocation(definitions: [crate, brokenCrate], location: .west(0))
    private static let middleCrates =   ObjectLocation(definitions: [crate, brokenCrate], location: .horizontal(0))
    private static let qCrates =        ObjectLocation(definitions: [crate, brokenCrate], location: .qHorizontal(0))
    private static let tqCrates =       ObjectLocation(definitions: [crate, brokenCrate], location: .tqHorizontal(0))
    
    private static let centerUrns =     ObjectLocation(definitions: [urnaCenter, urnbCenter, urncCenter],
                                                       location: .center(0, 0))
    private static let northUrns =      ObjectLocation(definitions: [urna, urnb, urnc], location: .north(0))
    private static let southUrns =      ObjectLocation(definitions: [urna, urnb, urnc], location: .south(0))
    private static let eastUrns =       ObjectLocation(definitions: [urna, urnb, urnc], location: .east(0))
    private static let westUrns =       ObjectLocation(definitions: [urna, urnb, urnc], location: .west(0))
    private static let middleUrns =     ObjectLocation(definitions: [urna, urnb, urnc], location: .horizontal(0))
    private static let qUrns =          ObjectLocation(definitions: [urna, urnb, urnc], location: .qHorizontal(0))
    private static let tqUrns =         ObjectLocation(definitions: [urna, urnb, urnc], location: .tqHorizontal(0))
    
    static let smallWarehouseRoomDefinition1 = RoomDefinition(minWidth: 2, minHeight: 2, maxWidth: 6, maxHeight: 6,
                                                              objectLocations: [AnyRoomDefinition.cornerNE,
                                                                                AnyRoomDefinition.cornerNW,
                                                                                AnyRoomDefinition.cornerSE,
                                                                                AnyRoomDefinition.cornerSW,
                                                                                centerCrates,])
    static let smallWarehouseRoomDefinition2 = RoomDefinition(minWidth: 2, minHeight: 2, maxWidth: 6, maxHeight: 6,
                                                              objectLocations: [AnyRoomDefinition.cornerNE,
                                                                                AnyRoomDefinition.cornerNW,
                                                                                AnyRoomDefinition.cornerSE,
                                                                                AnyRoomDefinition.cornerSW,
                                                                                northCrates,
                                                                                southCrates,
                                                                                eastCrates,
                                                                                westCrates,
                                                                               ])
    static let smallWarehouseRoomDefinition3 = RoomDefinition(minWidth: 2, minHeight: 2, maxWidth: 6, maxHeight: 6,
                                                              objectLocations: [AnyRoomDefinition.cornerNE,
                                                                                AnyRoomDefinition.cornerNW,
                                                                                AnyRoomDefinition.cornerSE,
                                                                                AnyRoomDefinition.cornerSW,
                                                                                centerUrns,])
    static let smallWarehouseRoomDefinition4 = RoomDefinition(minWidth: 2, minHeight: 2, maxWidth: 6, maxHeight: 6,
                                                              objectLocations: [AnyRoomDefinition.cornerNE,
                                                                                AnyRoomDefinition.cornerNW,
                                                                                AnyRoomDefinition.cornerSE,
                                                                                AnyRoomDefinition.cornerSW,
                                                                                northUrns,
                                                                                southUrns,
                                                                                eastUrns,
                                                                                westUrns,
                                                                               ])
    
    static let mediumWarehouseRoomDefinition = RoomDefinition(minWidth: 5, minHeight: 5, maxWidth: 7, maxHeight: 7,
                                                             objectLocations: [AnyRoomDefinition.cornerNE,
                                                                               AnyRoomDefinition.cornerNW,
                                                                               AnyRoomDefinition.cornerSE,
                                                                               AnyRoomDefinition.cornerSW,
                                                                               centerCrates,])
    
    static let largeWarehouseRoomDefinition1 = RoomDefinition(minWidth: 7, minHeight: 7, maxWidth: 9, maxHeight: 9,
                                                             objectLocations: [AnyRoomDefinition.cornerNE,
                                                                               AnyRoomDefinition.cornerNW,
                                                                               AnyRoomDefinition.cornerSE,
                                                                               AnyRoomDefinition.cornerSW,
                                                                               middleCrates,
                                                                               qCrates,
                                                                               tqCrates])
    
    static let largeWarehouseRoomDefinition2 = RoomDefinition(minWidth: 7, minHeight: 7, maxWidth: 9, maxHeight: 9,
                                                             objectLocations: [AnyRoomDefinition.cornerNE,
                                                                               AnyRoomDefinition.cornerNW,
                                                                               AnyRoomDefinition.cornerSE,
                                                                               AnyRoomDefinition.cornerSW,
                                                                               middleUrns,
                                                                               qUrns,
                                                                               tqUrns])
}
