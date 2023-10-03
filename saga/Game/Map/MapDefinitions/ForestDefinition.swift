//
//  ForestDefinition.swift
//  saga
//
//  Created by Christian McCartney on 6/30/22.
//

import Foundation

enum ForestDefinition {
    static let forestObjectPlacer = ObjectPlacer(roomDefinitions: [])
        
    static let mapGenerator = MapGenerator(width: STANDARD_MAP_SIZE,
                                           height: STANDARD_MAP_SIZE,
                                           objectPlacer: forestObjectPlacer)
    
    static let grassTileDefinition = TileGroupDefinition(
        name: "grass",
        verticalWallType: .stone,
        horizontalWallType: .stone,
        floorType: .grass)
    
    static let grassTileSet = TileSet(grassTileDefinition)
}
