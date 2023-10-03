//
//  MapController.swift
//  Saga
//
//  Created by Christian McCartney on 5/23/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftUI

public class MapController: ObservableObject {
    static let shared = MapController(tileSet: CryptDefinition.stoneTileSet,
                                      mapGenerator: CryptDefinition.dungeonGenerator)
    var graph: GKGridGraph<GKGridGraphNode>!
    weak var gameState: GameState!
    
    var tileMap: SKTileMapNode
    var tileSet: TileSet
    var mapGenerator: MapGenerator
    
    @Published var map: Map?
    private var validMap: Map
    private var emptyMap: Map
    
    var underlyingTileMap: TileMap
    
    private var mapController: MapController { MapController.shared }
    private var inited: Bool = false
    
    private init(tileSet: TileSet, mapGenerator: MapGenerator) {
        self.tileSet = tileSet
        self.mapGenerator = mapGenerator
        self.validMap = Array(repeating: Array(repeating: false, count: mapGenerator.width),
                              count: mapGenerator.height)
        self.emptyMap = Array(repeating: Array(repeating: false, count: mapGenerator.width),
                              count: mapGenerator.height)
        self.tileMap = SKTileMapNode(tileSet: tileSet,
                                     columns: mapGenerator.width,
                                     rows: mapGenerator.height,
                                     tileSize: tileSet.defaultTileSize)
        self.underlyingTileMap = Array(repeating: Array(repeating: 3, count: mapGenerator.width),
                                       count: mapGenerator.height)
        tileMap.lightingBitMask = LightingCategory.all
    }

    func generateMap() {
        let filledMap = mapGenerator.generate()
        map = filledMap.map
        
        graph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0),
                            width: Int32(tileMap.numberOfColumns),
                            height: Int32(tileMap.numberOfRows),
                            diagonalsAllowed: true)
        var walls = [GKGraphNode]()
        for x in 0..<tileMap.numberOfColumns {
            for y in 0..<tileMap.numberOfRows {
                let gridPosition = tileMap.mapGridPosition(for: Position(x, y), with: filledMap.map)
                underlyingTileMap[y][x] = gridPosition
                if let tileGroup = tileSet.mapTileDefinition(for: gridPosition) {
                    tileMap.setTileGroup(tileGroup, forColumn: x, row: y)
                }
                // CAREFUL: This will probably work but it leaves orphaned islands out of bounds
                if gridPosition != 0, let node = graph.node(atGridPosition: vector_int2(Int32(x), Int32(y))) {
                    walls.append(node)
                }
            }
        }
        
        for entity in filledMap.entities {
            entity.needsAbilityHighlight = false
            mapController.addChild(entity)
            if !entity.walkable, let node = graph.node(atGridPosition: vector_int2(Int32(entity.position.column), Int32(entity.position.row))) {
                walls.append(node)
            }
        }
        graph.remove(walls)
        
        if !inited {
            gameState.addChild(tileMap)
            inited = true
        }
    }
    
    func generateMap(tileSet: TileSet, mapGenerator: MapGenerator) {
        self.tileSet = tileSet
        self.mapGenerator = mapGenerator
        generateMap()
    }

    func updateValidArea(map: Map, offset: Position, center: Int, distance: Int) {
        validMap = emptyMap
        for col in center-distance-1..<center+distance+1 {
            for row in center-distance-1..<center+distance+1 {
                let p = Position(col, row) + offset
                if p.inbounds(validMap.count, validMap.count) {
                    validMap[p.row][p.column] = map[row][col]
                }
            }
        }
    }

    func checkValid(position: Position) -> Bool { validMap[position.row][position.column] }
}

// MARK: Accessing map properties
extension MapController {
    func centerOfTile(_ x: Int, _ y: Int) -> CGPoint { tileMap.centerOfTile(atColumn: x, row: y) }
    func tileColumnIndex(_ position: CGPoint) -> Int { tileMap.tileColumnIndex(fromPosition: position) }
    func tileRowIndex(_ position: CGPoint) -> Int { tileMap.tileRowIndex(fromPosition: position) }
    
    func fill() {
        tileMap.fill(with: nil)
        generateMap()
    }
}

// MARK: Adding and removing
extension MapController {
    func addAbilityNodes(_ node: SKSpriteNode) {
        gameState.abilityHighlightNodes.append(node)
        tileMap.addChild(node)
    }
    
    func removeAbilityNodes() {
        tileMap.removeChildren(in: gameState.abilityHighlightNodes)
        gameState.abilityHighlightNodes = []
    }

    func addChild(_ entity: Entity) {
        tileMap.addChild(entity.spriteNode)
        gameState.addChild(entity)
    }

    func addChildren( _ entities: [Entity]) {
        for entity in entities {
            addChild(entity)
        }
    }
    
    func removeChild(_ entity: Entity) {
        if !entity.walkable {
            let node = GKGridGraphNode(gridPosition: vector_int2(Int32(entity.position.column),
                                                                 Int32(entity.position.row)))
            graph.connectToAdjacentNodes(node: node)
        }
        tileMap.removeChildren(in: [entity.spriteNode])
        gameState.removeChild(entity)
    }
    
    func removeChildren(_ entities: [Entity]) {
        for entity in entities {
            removeChild(entity)
        }
    }

    func addChild(_ emitter: Emitter) {
        for child in emitter.emitters {
            tileMap.addChild(child)
        }
    }

    func removeChild(_ emitter: Emitter) {
        tileMap.removeChildren(in: emitter.emitters)
    }
    
    func addChild(_ node: SKNode) {
        tileMap.addChild(node)
    }
    
    func removeChildren(in nodes: [SKNode]) {
        tileMap.removeChildren(in: nodes)
    }
}
