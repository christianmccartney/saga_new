//
//  Entity.swift
//  Saga
//
//  Created by Christian McCartney on 5/23/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit
import Combine

enum MoveType {
    case walk
    case push
    case teleport
}

open class Entity: GKEntity, ObservableObject {
    let id: UUID
    var spriteNode: Node
    
    private var mapController: MapController { MapController.shared }
    private var map: SKTileMapNode { mapController.tileMap }

    public weak var entityDelegate: EntityDelegate?
    public var ai: EntityAI

    var type: EntityType
    var direction: EntityDirection
    var faction: EntityFaction
    
    var statistics: Statistics
    var position: Position
    
    var selectable = true
    var attackable = true
    var needsAbilityHighlight = true
    var walkable = false

    @Published var abilities: [Ability] = []
    var selectedAbility: Ability?
    
    var scale: CGFloat {
        get { spriteNode.xScale }
        set { spriteNode.setScale(newValue) }
    }

    var idleFrames: [EntityDirection: [SKTexture]] = [:]
    private var children = Set<Entity>()
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(id: UUID,
                spriteNode: Node,
                type: EntityType,
                position: Position,
                direction: EntityDirection = .down,
                faction: EntityFaction,
                statistics: Statistics = Statistics(),
                idleFrames: [EntityDirection: [SKTexture]] = [:],
                entityDelegate: EntityDelegate? = nil) {
        self.id = id
        self.spriteNode = spriteNode
        self.type = type
        self.position = position
        self.direction = direction
        self.faction = faction
        self.statistics = statistics
        self.idleFrames = idleFrames
        self.entityDelegate = entityDelegate
        self.ai = EntityAI()
        super.init()
        ai.entity = self
        spriteNode.nodeDelegate = self
        spriteNode.entity = self
        
        if let lightNode = type.lightNode {
            addChild(lightNode)
        }
        if faction == .player {
            addChild(playerLightNode)
        }
        spriteNode.lightingBitMask = type.lightingCategory
    }

    deinit {
        System.shared.removeEntity(self)
    }

    func addComponents(_ components: [Component]) {
        components.forEach { addComponent($0.copy()) }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func copyEntity() -> Entity {
        let entity = Entity(id: UUID(), spriteNode: spriteNode.copy(), type: type, position: position, direction: direction, faction: faction, statistics: statistics, idleFrames: idleFrames, entityDelegate: entityDelegate)
        entity.addComponents(components.compactMap { $0 as? Component })
        System.shared.addEntity(entity)
        return entity
    }

    var name: String {  "\(type)" }


    private func angle(to: simd_float2) -> Float {
        let from = direction.directionVector
        let dot = dot(from, to)
        return acos(dot)
    }

    private func direction(to newLocation: CGPoint) -> simd_float2 {
        let spriteNodePosition = simd_float2(Float(spriteNode.position.x), Float(spriteNode.position.y))
        let newLocationVector = simd_float2(Float(newLocation.x), Float(newLocation.y))
        let direction = normalize(newLocationVector - spriteNodePosition)
        return direction
    }
    
    func rotation(to newLocation: CGPoint) -> EntityDirection? {
        let direction = direction(to: newLocation)
        if let entityDirection = EntityDirection.fromDirection(direction) {
            return entityDirection
        }
        let angle = angle(to: direction)
        if angle > Float.pi/2 {
            return EntityDirection(rawValue: (self.direction.rawValue + 2) % 4)
        }
        return nil
    }

    // used in move action
    func move(to location: CGPoint, from scene: SKScene, _ closure: @escaping () -> ()) {
        let pos = scene.convert(location, to: map)
        let column = mapController.tileColumnIndex(pos)
        let row = mapController.tileRowIndex(pos)
//        let center = mapController.centerOfTile(column, row)
        guard let fromNode = mapController.graph.node(atGridPosition: vector_int2(Int32(position.column),
                                                                                  Int32(position.row))),
              let toNode = mapController.graph.node(atGridPosition: vector_int2(Int32(column),
                                                                                Int32(row))) else {
                  closure()
                  return
              }
        let path = mapController.graph.findPath(from: fromNode, to: toNode).compactMap { $0 as? GKGridGraphNode }
        guard path.count >= 2 else {
            closure()
            return
        }
        
        var actions = [SKAction]()
        for i in 1..<path.count {
            let location = path[i].gridPosition
            actions.append(SKAction.move(to: mapController.centerOfTile(Int(location.x), Int(location.y)),
                                         duration: 0.25))
        }
        
        let sequence = SKAction.sequence(actions)
//        guard mapController.map[row][column] else { return }
//        if let newDirection = rotation(to: center) {
//            direction = newDirection
//        }
//        let action = SKAction.move(to: center, duration: 0.25)
        position = Position(column, row)
        spriteNode.run(sequence) {
            closure()
        }
    }

    // TODO 7: Need to distinguish different types of moves, eg. walked pushed teleported etc
    // used in dash animation
    func move(to position: Position, _ closure: @escaping () -> ()) {
        guard mapController.map![position.row][position.column] else { return }
        let location = mapController.centerOfTile(position.column, position.row)
        if let newDirection = rotation(to: location) {
            direction = newDirection
        }
        let action = SKAction.move(to: location, duration: 0.25)
        self.position = position
        spriteNode.run(action) {
            closure()
        }
    }
    
//    func move(to position: Position) async {
//        if let map = map {
//            guard await map.map[position.row][position.column] else { return }
//            let location = await map.centerOfTile(atColumn: position.column, row: position.row)
//            if let newDirection = rotation(to: location) {
//                direction = newDirection
//            }
//            let action = SKAction.move(to: location, duration: 0.25)
//            self.position = position
//            await spriteNode.run(action)
//        }
//    }

//    func wait() async {
//        let action = SKAction.wait(forDuration: 0.25)
//        await spriteNode.run(action)
//    }

    func check(_ statistic: StatisticType) -> Int {
        return statistics.checkStat(statistic)
    }

    var isUserInteractionEnabled: Bool {
        get {
            spriteNode.isUserInteractionEnabled
        }
        set {
            spriteNode.isUserInteractionEnabled = newValue
        }
    }

    public func touchDown(_ pos: CGPoint) {
        entityDelegate?.touchDown(pos, entity: self)
    }

    public func touchMoved(_ pos: CGPoint) {
        entityDelegate?.touchMoved(pos, entity: self)
    }

    public func touchUp(_ pos: CGPoint) {
        entityDelegate?.touchUp(pos, entity: self)
    }

    func nearbyEntities(within range: Int) -> [Entity] {
        entityDelegate?.nearbyEntities(to: self, within: 0...range) ?? []
    }

    func nearbyEntities(within range: ClosedRange<Int>) -> [Entity] {
        entityDelegate?.nearbyEntities(to: self, within: range) ?? []
    }

    var nearbyEntities: [Entity] {
        entityDelegate?.nearbyEntities(to: self, within: 0...5) ?? []
    }
}

// MARK: Helper Functions
extension Entity {
    open override var description: String {
        return "\(name)"
    }
    
    func inspectorDescription(inspectorWidth: Int) -> String {
        var line: String = ""
        for _ in 0..<inspectorWidth-1 {
            line.append("-")
        }
        return "\(name)\n\(line)\(statistics.inspectorDescription)"
    }
}

// MARK: Forwading to underlying SpriteNode
extension Entity {
    
    // TODO: Figure out a nicer solution for this position mess
    func updatePosition() {
        spriteNode.position = mapController.centerOfTile(position.column, position.row)
    }
    
    func setPosition(_ position: Position) {
        self.position = position
        spriteNode.position = mapController.centerOfTile(position.column, position.row)
    }
    
    var mapPosition: CGPoint { mapController.centerOfTile(position.column, position.row) }
    
    func addChild(_ entity: Entity) {
        children.insert(entity)
        spriteNode.addChild(entity.spriteNode)
    }
    
    func removeChild(_ entity: Entity) {
        children.remove(entity)
        spriteNode.removeChildren(in: [entity.spriteNode])
    }
    
    func addChild(_ node: SKNode) { spriteNode.addChild(node) }
    func addChildren(_ nodes: [SKNode]) { nodes.forEach { addChild($0) } }
    func removeChild(_ node: SKNode) { spriteNode.removeChildren(in: [node]) }
    func removeChildren(_ nodes: [SKNode]) { spriteNode.removeChildren(in: nodes) }
}

extension Entity {
    var playerLightNode: SKLightNode {
        let light = SKLightNode()
        light.categoryBitMask = LightingCategory.player
        light.lightColor = .white
        light.falloff = 2.5
        return light
    }
}
