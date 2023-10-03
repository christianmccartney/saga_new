//
//  SKTileMapNode.swift
//  saga
//
//  Created by Christian McCartney on 11/18/21.
//

import SpriteKit
import GameplayKit

extension SKTileMapNode {
    func fillSquare(_ tileGroup: SKTileGroup) {
        for column in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                let gridPosition = interfaceGridPosition(for: Position(column, row))
                if let tileDefinition = tileGroup.interfaceTileDefinition(for: gridPosition) {
                    setTileGroup(tileGroup,
                                 andTileDefinition: tileDefinition,
                                 forColumn: column,
                                 row: row)
                }
            }
        }
    }
    
    func fillAbilityCircle(_ tileGroup: SKTileGroup,
                           _ distance: Int,
                           _ position: Position,
                           _ underlyingMap: Map) {
        var fillMap: Map = Array(repeating: Array(repeating: false, count: numberOfColumns + 2),
                                     count: numberOfRows + 2)
        let center = (numberOfRows/2)+1
        let offset = position - Position(center, center)
        
        for col in center-distance-1..<center+distance+1 {
            for row in center-distance-1..<center+distance+1 {
                let p = Position(col, row) + offset
                // CAREFUL: This only works if I keep the maps square
                if p.inbounds(underlyingMap.count, underlyingMap.count), underlyingMap[p.row][p.column] {
                    if p.distance(position) < distance {
                        fillMap[row][col] = true
                   }
                }
            }
        }
        MapController.shared.updateValidArea(map: fillMap, offset: offset, center: center, distance: distance)
        
        for col in center-distance-1..<center+distance+1 {
            for row in center-distance-1..<center+distance+1 {
                var tileDefinition: SKTileDefinition?
                if fillMap[row][col] {
                    tileDefinition = highlight(col: col, row: row, fillMap: fillMap, tileGroup: tileGroup)
                }
                
                if let td = tileDefinition {
                    setTileGroup(tileGroup, andTileDefinition: td, forColumn: col - 1, row: row - 1)
                }
            }
        }
    }

    func fillMovementCircle(_ tileGroup: SKTileGroup,
                            _ distance: Int,
                            _ position: Position,
                            _ underlyingMap: Map,
                            _ graph: GKGridGraph<GKGridGraphNode>) {
        guard let node = graph.node(atGridPosition: vector_int2(x: Int32(position.column), y: Int32(position.row))) else { return }
        var fillMap: Map = Array(repeating: Array(repeating: false, count: numberOfColumns + 2),
                                     count: numberOfRows + 2)
        let center = (numberOfRows/2)+1
        let offset = position - Position(center, center)
        
        for col in center-distance-1..<center+distance+1 {
            for row in center-distance-1..<center+distance+1 {
                let p = Position(col, row) + offset
                // CAREFUL: This only works if I keep the maps square
                if p.inbounds(underlyingMap.count, underlyingMap.count), underlyingMap[p.row][p.column] {
//                    let walkable = nearbyEntities.first { $0.position == p && !$0.walkable } == nil
                    if let toNode = graph.node(atGridPosition: vector_int2(x: Int32(p.column), y: Int32(p.row))),
                       graph.findPath(from: node, to: toNode).count-2 < distance {
                        fillMap[row][col] = true
                   }
                }
            }
        }
        MapController.shared.updateValidArea(map: fillMap, offset: offset, center: center, distance: distance)

        for col in center-distance-1..<center+distance+1 {
            for row in center-distance-1..<center+distance+1 {
                var tileDefinition: SKTileDefinition?
                if fillMap[row][col] {
                    tileDefinition = highlight(col: col, row: row, fillMap: fillMap, tileGroup: tileGroup)
                }
                
                if let td = tileDefinition {
                    setTileGroup(tileGroup, andTileDefinition: td, forColumn: col - 1, row: row - 1)
                }
            }
        }
    }
}

extension SKTileMapNode {
    fileprivate func highlight(col: Int, row: Int, fillMap: Map, tileGroup: SKTileGroup) -> SKTileDefinition? {
        let n = fillMap[row+1][col]
        let s = fillMap[row-1][col]
        let e = fillMap[row][col+1]
        let w = fillMap[row][col-1]
        
        let ne = fillMap[row+1][col+1]
        let nw = fillMap[row+1][col-1]
        let se = fillMap[row-1][col+1]
        let sw = fillMap[row-1][col-1]
        
        let neighbors = [n, s, e, w].compactMap { $0 ? true : nil }.count
        let diagonals = [ne, nw, se, sw].compactMap { $0 ? true : nil }.count
        if neighbors == 4 {
            // 1 1 0
            // 1 1 1
            // 1 1 1
            if diagonals == 3 {
                if !ne {
                    return tileGroup.interfaceTileDefinition(for: 15)
                }
                if !nw {
                    return tileGroup.interfaceTileDefinition(for: 18)
                }
                if !se {
                    return tileGroup.interfaceTileDefinition(for: 16)
                }
                if !sw {
                    return tileGroup.interfaceTileDefinition(for: 17)
                }
            // 0 1 0
            // 1 1 1
            // 1 1 1
            // or
            // 0 1 1
            // 1 1 1
            // 1 1 0
            } else if diagonals == 2 {
                if !ne, !nw {
                    return tileGroup.interfaceTileDefinition(for: 19)
                }
                if !ne, !se {
                    return tileGroup.interfaceTileDefinition(for: 20)
                }
                if !se, !sw {
                    return tileGroup.interfaceTileDefinition(for: 21)
                }
                if !sw, !nw {
                    return tileGroup.interfaceTileDefinition(for: 22)
                }
                if !nw, !se {
                    return tileGroup.interfaceTileDefinition(for: 45)
                }
                if !ne, !sw {
                    return tileGroup.interfaceTileDefinition(for: 46)
                }
            // 0 1 0
            // 1 1 1
            // 1 1 0
            } else if diagonals == 1 {
                if se {
                    return tileGroup.interfaceTileDefinition(for: 41)
                }
                if sw {
                    return tileGroup.interfaceTileDefinition(for: 42)
                }
                if nw {
                    return tileGroup.interfaceTileDefinition(for: 43)
                }
                if ne {
                    return tileGroup.interfaceTileDefinition(for: 44)
                }
            }
        } else if neighbors == 3 {
            // 1 1 1
            // 1 1 1
            // 1 0 1
            if diagonals == 4 {
                if !n {
                    return tileGroup.interfaceTileDefinition(for: 2)
                }
                if !s {
                    return tileGroup.interfaceTileDefinition(for: 8)
                }
                if !e {
                    return tileGroup.interfaceTileDefinition(for: 6)
                }
                if !w {
                    return tileGroup.interfaceTileDefinition(for: 4)
                }
            // 1 1 0
            // 1 1 0
            // 1 1 1
            // or
            // 1 0 1
            // 1 1 1
            // 1 1 0
            } else if diagonals == 3 {
                if !n, !se {
                    return tileGroup.interfaceTileDefinition(for: 33)
                }
                if !n, !sw {
                    return tileGroup.interfaceTileDefinition(for: 37)
                }
                if !s, !nw {
                    return tileGroup.interfaceTileDefinition(for: 36)
                }
                if !s, !ne {
                    return tileGroup.interfaceTileDefinition(for: 40)
                }
                if !e, !sw {
                    return tileGroup.interfaceTileDefinition(for: 35)
                }
                if !e, !nw {
                    return tileGroup.interfaceTileDefinition(for: 39)
                }
                if !w, !ne {
                    return tileGroup.interfaceTileDefinition(for: 34)
                }
                if !w, !se {
                    return tileGroup.interfaceTileDefinition(for: 38)
                }
                if !n {
                    return tileGroup.interfaceTileDefinition(for: 2)
                }
                if !s {
                    return tileGroup.interfaceTileDefinition(for: 8)
                }
                if !e {
                    return tileGroup.interfaceTileDefinition(for: 6)
                }
                if !w {
                    return tileGroup.interfaceTileDefinition(for: 4)
                }
                // 1 1 0
                // 1 1 0
                // 1 1 0
                // or
                // 1 1 1
                // 0 1 1
                // 0 1 0
            } else if diagonals == 2 {
                if !n, !se {
                    return tileGroup.interfaceTileDefinition(for: 33)
                }
                if !n, !sw {
                    return tileGroup.interfaceTileDefinition(for: 37)
                }
                if !s, !nw {
                    return tileGroup.interfaceTileDefinition(for: 36)
                }
                if !s, !ne {
                    return tileGroup.interfaceTileDefinition(for: 40)
                }
                if !e, !sw {
                    return tileGroup.interfaceTileDefinition(for: 35)
                }
                if !e, !nw {
                    return tileGroup.interfaceTileDefinition(for: 39)
                }
                if !w, !ne {
                    return tileGroup.interfaceTileDefinition(for: 34)
                }
                if !w, !se {
                    return tileGroup.interfaceTileDefinition(for: 38)
                }
                if !n {
                    return tileGroup.interfaceTileDefinition(for: 2)
                }
                if !s {
                    return tileGroup.interfaceTileDefinition(for: 8)
                }
                if !e {
                    return tileGroup.interfaceTileDefinition(for: 6)
                }
                if !w {
                    return tileGroup.interfaceTileDefinition(for: 4)
                }
                // 1 1 0
                // 1 1 0
                // 0 1 0
                // or
                // 0 1 0
                // 1 1 0
                // 0 1 1
            } else if diagonals == 1 {
                if !n, !se {
                    if !sw {
                        return tileGroup.interfaceTileDefinition(for: 29)
                    }
                    return tileGroup.interfaceTileDefinition(for: 33)
                }
                if !n, !sw {
                    return tileGroup.interfaceTileDefinition(for: 37)
                }
                if !s, !nw {
                    if !ne {
                        return tileGroup.interfaceTileDefinition(for: 32)
                    }
                    return tileGroup.interfaceTileDefinition(for: 36)
                }
                if !s, !ne {
                    return tileGroup.interfaceTileDefinition(for: 40)
                }
                if !e, !sw {
                    if !nw {
                        return tileGroup.interfaceTileDefinition(for: 31)
                    }
                    return tileGroup.interfaceTileDefinition(for: 35)
                }
                if !e, !nw {
                    return tileGroup.interfaceTileDefinition(for: 39)
                }
                if !w, !ne {
                    if !se {
                        return tileGroup.interfaceTileDefinition(for: 30)
                    }
                    return tileGroup.interfaceTileDefinition(for: 34)
                }
                if !w, !se {
                    return tileGroup.interfaceTileDefinition(for: 38)
                }
                // 0 0 0
                // 1 1 1
                // 0 1 0
            } else if diagonals == 0 {
                if !n {
                    return tileGroup.interfaceTileDefinition(for: 29)
                }
                if !s {
                    return tileGroup.interfaceTileDefinition(for: 32)
                }
                if !e {
                    return tileGroup.interfaceTileDefinition(for: 31)
                }
                if !w {
                    return tileGroup.interfaceTileDefinition(for: 30)
                }
            }
        } else if neighbors == 2 {
            // 1 1 1
            // 1 1 0
            // 1 0 1
            if diagonals == 4 {
                if !n, !s {
                    return tileGroup.interfaceTileDefinition(for: 23)
                }
                if !e, !w {
                    return tileGroup.interfaceTileDefinition(for: 24)
                }
                if !n, !e {
                    return tileGroup.interfaceTileDefinition(for: 3)
                }
                if !n, !w {
                    return tileGroup.interfaceTileDefinition(for: 1)
                }
                if !s, !e {
                    return tileGroup.interfaceTileDefinition(for: 9)
                }
                if !s, !w {
                    return tileGroup.interfaceTileDefinition(for: 7)
                }
            // 0 1 1
            // 0 1 0
            // 1 1 1
            // or
            // 1 0 0
            // 1 1 0
            // 1 1 1
            } else if diagonals == 3 {
                if n, s {
                    return tileGroup.interfaceTileDefinition(for: 24)
                }
                if e, w {
                    return tileGroup.interfaceTileDefinition(for: 23)
                }
                if !n, !e {
                    return tileGroup.interfaceTileDefinition(for: 3)
                }
                if !n, !w {
                    return tileGroup.interfaceTileDefinition(for: 1)
                }
                if !s, !w {
                    return tileGroup.interfaceTileDefinition(for: 7)
                }
                if !s, !e {
                    return tileGroup.interfaceTileDefinition(for: 9)
                }
                // 1 0 0
                // 1 1 0
                // 1 1 0
            } else if diagonals == 2 {
                if !n, !s {
                    return tileGroup.interfaceTileDefinition(for: 23)
                }
                if !e, !w {
                    return tileGroup.interfaceTileDefinition(for: 24)
                }
                if !n, !e {
                    return tileGroup.interfaceTileDefinition(for: 3)
                }
                if !n, !w {
                    return tileGroup.interfaceTileDefinition(for: 1)
                }
                if !s, !e {
                    return tileGroup.interfaceTileDefinition(for: 9)
                }
                if !s, !w {
                    return tileGroup.interfaceTileDefinition(for: 7)
                }
                // 0 1 0
                // 0 1 0
                // 1 1 0
                // or
                // 0 0 0
                // 1 1 0
                // 1 1 0
                // or
                // 1 1 0
                // 0 1 1
                // 0 0 0
             } else if diagonals == 1 {
                 if n, s {
                     return tileGroup.interfaceTileDefinition(for: 24)
                 }
                 if e, w {
                     return tileGroup.interfaceTileDefinition(for: 23)
                 }
                 if n, e {
                     if ne {
                         return tileGroup.interfaceTileDefinition(for: 7)
                     }
                     return tileGroup.interfaceTileDefinition(for: 27)
                 }
                 if n, w {
                     if nw {
                         return tileGroup.interfaceTileDefinition(for: 9)
                     }
                     return tileGroup.interfaceTileDefinition(for: 28)
                 }
                 if s, e {
                     if se {
                         return tileGroup.interfaceTileDefinition(for: 1)
                     }
                     return tileGroup.interfaceTileDefinition(for: 25)
                 }
                 if s, w {
                     if sw {
                         return tileGroup.interfaceTileDefinition(for: 3)
                     }
                     return tileGroup.interfaceTileDefinition(for: 26)
                 }
                // 0 0 0
                // 0 1 1
                // 0 1 0
                // or
                // 0 0 0
                // 1 1 1
                // 0 0 0
             } else if diagonals == 0 {
                 if n, s {
                     return tileGroup.interfaceTileDefinition(for: 24)
                 }
                 if e, w {
                     return tileGroup.interfaceTileDefinition(for: 23)
                 }
                 if n, e {
                     return tileGroup.interfaceTileDefinition(for: 27)
                 }
                 if n, w {
                     return tileGroup.interfaceTileDefinition(for: 28)
                 }
                 if s, e {
                     return tileGroup.interfaceTileDefinition(for: 25)
                 }
                 if s, w {
                     return tileGroup.interfaceTileDefinition(for: 26)
                 }
             }
            // 1 0 0
            // 1 1 0
            // 1 0 0
        } else if neighbors == 1 {
            if n {
                return tileGroup.interfaceTileDefinition(for: 11)
            }
            if s {
                return tileGroup.interfaceTileDefinition(for: 13)
            }
            if e {
                return tileGroup.interfaceTileDefinition(for: 12)
            }
            if w {
                return tileGroup.interfaceTileDefinition(for: 14)
            }
        } else if neighbors == 0 {
            if diagonals > 0 {
                return tileGroup.interfaceTileDefinition(for: 10)
            }
        }
        return tileGroup.interfaceTileDefinition(for: 0)
    }
}

// 6 7 8
// 3 4 5
// 0 1 2

extension SKTileMapNode {
    func interfaceGridPosition(for tileLocation: Position, span: Int? = nil) -> Int {
        if let span = span {
            return interfaceGridPosition(for: tileLocation, rows: span, cols: span)
        } else {
            return interfaceGridPosition(for: tileLocation, rows: numberOfRows, cols: numberOfColumns)
        }
    }
    
    func interfaceGridPosition(for tileLocation: Position, rows: Int, cols: Int) -> Int {
        if tileLocation.column == 0 {
            if tileLocation.row == 0 {
                return 6
            }
            if tileLocation.row == rows-1 {
                return 0
            }
            return 3
        }
        if tileLocation.column == cols-1 {
            if tileLocation.row == 0 {
                return 8
            }
            if tileLocation.row == rows-1 {
                return 2
            }
            return 5
        }
        if tileLocation.row == 0 {
            return 7
        }
        if tileLocation.row == rows-1 {
            return 1
        }
        return 4
    }
}

// 0 = floor
// 1 = horizontal
// 2 = vertical
// 3 = none

// 2 1 1 1 2
// 2 0 0 0 2
// 2 0 0 0 2
// 2 0 0 0 2
// 2 2 2 2 2

extension SKTileMapNode {
    func mapGridPosition(for tileLocation: Position, with map: Map) -> Int {
        if map[tileLocation.row][tileLocation.column] {
            return 0
        }
        let y1 = tileLocation.row - 1
        let y2 = tileLocation.row + 1
        let x1 = tileLocation.column - 1
        let x2 = tileLocation.column + 1
        guard y2 < map.count else {
            return 3
        }
        guard x2 < map[0].count else {
            return 3
        }
        guard y1 >= 0 else {
            return 3
        }
        guard x1 >= 0 else {
            return 3
        }
        if map[y1][tileLocation.column] {
            return 1
        }
        if map[y2][tileLocation.column] {
            return 2
        }
        if map[tileLocation.row][x1] {
            return 2
        }
        if map[tileLocation.row][x2] {
            return 2
        }
        if ((map[y1][x1] != map[y2][x1]) != map[y1][x2]) != map[y2][x2] {
            return 2
        }
        let neighbors = (map[y1][x1] + map[y2][x1]) + (map[y1][x2] + map[y2][x2])
        if neighbors == 2 || neighbors == 4 {
            return 2
        }
        return 3
    }
}
