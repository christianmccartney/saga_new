//
//  EntityDelegate.swift
//  saga
//
//  Created by Christian McCartney on 10/21/21.
//

import CoreGraphics

extension GameState: EntityDelegate {
    public func touchDown(_ pos: CGPoint, entity: Entity? = nil) {
        offerTurn(pos, entity)
        //print("touch down \(pos) : \(entity?.type)")
    }
    
    public func touchMoved(_ pos: CGPoint, entity: Entity? = nil) {
        //print("touch moved \(pos) : \(entity?.type)")
    }
    
    public func touchUp(_ pos: CGPoint, entity: Entity? = nil) {
        //print("touch up \(pos) : \(entity?.type)")
    }

    public func nearbyEntities(to entity: Entity, within range: ClosedRange<Int>) -> [Entity] {
        var nearbyEntities = [Entity]()
//        for e in entities {
//            if entity != e {
//                if range.contains(entity.position.distance(e.position)) {
//                    nearbyEntities.append(e)
//                }
//            }
//        }
//        return nearbyEntities
        let x1 = entity.position.column - range.upperBound
        let x2 = entity.position.column + range.upperBound
        let y1 = entity.position.row - range.upperBound
        let y2 = entity.position.row + range.upperBound
        
        for x in x1...x2 {
            for y in y1...y2 {
                if entity.position.column == x, entity.position.row == y { continue }
                let point = mapController.tileMap.centerOfTile(atColumn: x, row: y)
                nearbyEntities.append(contentsOf: mapController.tileMap.nodes(at: point).compactMap { ($0 as? Node)?._entity })
            }
        }
        return nearbyEntities
    }
}
