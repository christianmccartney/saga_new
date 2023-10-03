//
//  CryptDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

enum CryptDefinition {
    static let cryptObjectPlacer = ObjectPlacer(
        roomDefinitions: [LibraryRoomDefinition.smallLibraryRoomDefinition,
                          LibraryRoomDefinition.mediumLibraryRoomDefinition,
                          WarehouseRoomDefinition.smallWarehouseRoomDefinition1,
                          WarehouseRoomDefinition.smallWarehouseRoomDefinition2,
                          WarehouseRoomDefinition.smallWarehouseRoomDefinition3,
                          WarehouseRoomDefinition.smallWarehouseRoomDefinition4,
                          WarehouseRoomDefinition.mediumWarehouseRoomDefinition,
                          WarehouseRoomDefinition.largeWarehouseRoomDefinition1,
                          WarehouseRoomDefinition.largeWarehouseRoomDefinition2,
                         ])
    static let dungeonGenerator = MapGenerator(width: STANDARD_MAP_SIZE,
                                               height: STANDARD_MAP_SIZE,
                                               objectPlacer: cryptObjectPlacer)
    
    static let stoneTileDefinition = TileGroupDefinition(
        name: "stoneCobble",
        verticalWallType: .stone,
        horizontalWallType: .stone,
        floorType: .cobble2)
    
    static let stoneTileSet = TileSet(stoneTileDefinition)
}
