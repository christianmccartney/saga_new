//
//  GameState.swift
//  saga
//
//  Created by Christian McCartney on 10/21/21.
//

import SpriteKit
import Combine

open class GameState: InputManager, StateMachine {
    var cameraNode: Camera!
    var interface: Interface { Interface.shared }
    var mapController: MapController { MapController.shared }
    
    private var cancellables = Set<AnyCancellable>()

    var entities = Set<Entity>()
    var abilityHighlightNodes = [SKSpriteNode]()
    var highlightNode: SKSpriteNode?

    public private(set) var acting: Bool = false

    // MARK: - Game State
    
    var sortedEntities: [Entity] {
        get {
            entities.compactMap { $0 as? Creature }.sorted { $0.statistics.checkStat(.initiative) > $1.statistics.checkStat(.initiative) }
        }
    }
    
    private var map: SKTileMapNode { mapController.tileMap }

    var inCombat: Bool = false

    // take snapshot of the order of entities
    private var currentCombatOrder: [Entity] = []
    // remember which one is acting next
    private var currentCombatIndex: Int = 0
    // remember the number of entities we had in case some new ones get added (necessary?)
    private var currentCombatCount: Int = 0
    
    private var playerAbilitiesToken: AnyCancellable?

    @Published var activeEntity: Entity? = nil
    @Published var playerEntity: Entity? = nil {
        didSet {
            if let playerEntity = playerEntity {
                playerAbilitiesToken = playerEntity.$abilities.sink { [weak self] abilities in
                    guard let self = self else { return }
                    self.playerAbilities = abilities
                    self.truncatedAbilities = self.trucatingAbilities(abilities)
                }
            }
        }
    }
    @Published var highlightedEntity: Entity? = nil {
        didSet {
            updateHints(highlightedEntity, selectedAbility)
        }
    }
    @Published var selectedAbility: Ability? = nil {
        didSet {
            updateHints(highlightedEntity, selectedAbility)
        }
    }
    @Published var playerAbilities: [Ability] = []
    @Published var truncatedAbilities: [Ability?] = []
    
    private func trucatingAbilities(_ abilities: [Ability]) -> [Ability?] {
        var truncatedAbilities: [Ability?] = Array(repeating: nil, count: 9)
        for i in 0..<abilities.count {
            truncatedAbilities[i] = abilities[i]
        }
        return truncatedAbilities
    }

    private func updateActiveEntity() {
        guard currentCombatIndex < currentCombatOrder.count else {
            highlightedEntity = nil
            activeEntity = nil
            return
        }
        let activeEntity = currentCombatOrder[currentCombatIndex]
        Selection.shared.highlight(activeEntity)
        self.activeEntity = activeEntity
    }
    
    func setupSubscriptions() {
    }
    
    private func updateHints(_ entity: Entity? = nil, _ ability: Ability? = nil) {
        if let entity = highlightedEntity {
            if entity.faction == .player {
                if let ability = selectedAbility {
                    mapController.clearHints(from: entity)
                    mapController.clearAttackHints()
                    mapController.setRangeHints(on: entity, ability: ability)
                    mapController.addAttackHints(to: entity, ability: ability)
                } else {
                    mapController.clearHints(from: entity)
                    mapController.clearAttackHints()
                    mapController.setMovementHints(on: entity)
                }
            } else if let playerEntity = playerEntity {
                mapController.clearHints(from: playerEntity)
                mapController.clearAttackHints()
            }
        }
    }

    func beginCombat() {
        inCombat = true
        currentCombatOrder = sortedEntities
        currentCombatCount = currentCombatOrder.count
        updateActiveEntity()
        focusOnActive()
    }

    // This is not how it should work
    private func recalculateCombatOrder() {
        currentCombatOrder = sortedEntities
        currentCombatCount = currentCombatOrder.count
        updateActiveEntity()
    }

    func removeFromCombat(_ entity: Entity) {
        entities.remove(entity)
        recalculateCombatOrder()
    }
    
    public func offerTurn(_ closure: @escaping (Bool) -> Void) {
        if let activeEntity = activeEntity, activeEntity.faction != .player {
            acting = true
            // do an ai here
            if let position = activeEntity.ai.createAction() {
                aiInput(position, .move) { success in
                    if success {
                        self.advanceTurn()
                        closure(true)
                        return
                    } else {
                        self.acting = false
                    }
                }
            } else {
                aiInput(nil) { success in
                    if success {
                        self.advanceTurn()
                        closure(true)
                        return
                    } else {
                        self.acting = false
                    }
                }
            }
        }
    }

    public func offerTurn(_ position: CGPoint, _ entity: Entity?) {
        if let activeEntity = activeEntity, activeEntity.faction == .player {
            input(position, entity) { success in
                if success {
                    self.advanceTurn()
                } else {
                    self.acting = false
                }
            }
        }
    }
    
    private func input(_ position: CGPoint, _ entity: Entity?, _ closure: @escaping (Bool) -> ()) {
        guard !acting else {
            closure(false)
            return
        }
        if inCombat {
            if highlightedEntity == nil, let entity = entity {
                Selection.shared.highlight(entity)
                closure(false)
                return
            }
            
            // touched an entity, highlight it
            if let entity = entity {
                // have a selected ability, try to do it on the selected entity
                if let activeEntity = activeEntity,
                   highlightedEntity == activeEntity,
                   let ability = selectedAbility {
                    acting = true
                    if mapController.checkValid(position: entity.position) {
                        ability.act(from: activeEntity, on: entity, position: entity.position) { success in
                            if success {
    //                            Selection.shared.unhighlight()
                                closure(true)
                                return
                            } else {
                                closure(false)
                            }
                        }
                    }
                }

                // if we couldnt act on self, but we selected self, then deselect self
//                if entity == highlightedEntity {
//                    Selection.shared.unhighlight()
//                    closure(false)
//                    return
//                }
                // no selected ability, move instead
                if selectedAbility == nil, let activeEntity = activeEntity, entity.walkable, let scene = scene {
                    let touchPosition = Position(map.tileColumnIndex(fromPosition: position),
                                                 map.tileRowIndex(fromPosition: position))
                    if mapController.checkValid(position: touchPosition) {
                        acting = true
                        activeEntity.move(to: position, from: scene) {
//                            Selection.shared.unhighlight()
                            closure(true)
                        }
                        return
                    }
                }
                
                // otherwise the selected entity was out of range of the selected ability, so select that entity
                if entity.selectable {
                    Selection.shared.highlight(entity)
                    closure(false)
                }
                return
            } else { // touched an empty square
    
                // if theres an active entity but it isnt the selected entity, dont do an action
                if let activeEntity = activeEntity, highlightedEntity != activeEntity {
                    closure(false)
                    return
                }
                
                if let activeEntity = activeEntity, let scene = scene {
                    let touchPosition = Position(map.tileColumnIndex(fromPosition: position),
                                                 map.tileRowIndex(fromPosition: position))
                    // gonna do an action
                    if highlightedEntity == activeEntity,
                       let ability = activeEntity.selectedAbility {
                        acting = true
                        if mapController.checkValid(position: touchPosition) {
                            ability.act(from: activeEntity, on: nil, position: touchPosition) { success in
                                if success {
    //                                Selection.shared.unhighlight()
                                    closure(true)
                                } else {
                                    closure(false)
                                }
                            }
                        }
                        return
                    }
                    
                    // no selected ability, move instead
                    if mapController.checkValid(position: touchPosition) {
                        acting = true
                        activeEntity.move(to: position, from: scene) {
//                            Selection.shared.unhighlight()
                            closure(true)
                        }
                        return
                    }
                }
            }
        }
        closure(false)
    }

    private func aiInput(_ position: Position?, _ action: EntityAction = .none, _ closure: @escaping (Bool) -> ()) {
        switch action {
        case .none:
            let action = SKAction.wait(forDuration: 0.25)
            activeEntity?.spriteNode.run(action) {
                closure(true)
            }
            return
        case .move:
            if let position = position, let entity = activeEntity {
                guard mapController.map![position.row][position.column] else { return }
                let location = mapController.centerOfTile(position.column, position.row)
                if let newDirection = entity.rotation(to: location) {
                    entity.direction = newDirection
                }
                let action = SKAction.move(to: location, duration: 0.25)
                entity.position = position
                entity.spriteNode.run(action) {
                    closure(true)
                }
                return
            }
        case .attack:
            break
        case .cast:
            break
        case .defend:
            break
        }
        closure(false)
    }

    public func advanceTurn() {
        acting = false
        currentCombatIndex = (currentCombatIndex + 1) % currentCombatOrder.count
        updateActiveEntity()
    }

    // MARK: --------------------

    func pause(_ pause: Bool) {
        isPaused = pause
        map.isPaused = pause
        for entity in entities {
            entity.spriteNode.isPaused = pause
        }
    }

    // MARK: - Adding/Removing things
    func addChild(_ entity: Entity) {
        entities.insert(entity)
        entity.entityDelegate = self
    }
    
    func addChildren(_ entities: [Entity]) {
        for entity in entities {
            addChild(entity)
        }
    }
    
    func removeChild(_ entity: Entity) {
        entities.remove(entity)
        if inCombat { recalculateCombatOrder() }
    }
    
    func removeChildren(_ entities: [Entity]) {
        for entity in entities {
            removeChild(entity)
        }
    }

    func track(_ entity: Entity) {
        entities.insert(entity)
    }

    func untrack(_ entity: Entity) {
        entities.remove(entity)
    }

    // MARK: - Camera
    func focusOnActive() {
        if let mapPosition = activeEntity?.mapPosition {
            cameraNode.position = map.convert(mapPosition, to: self)
        }
    }

    // MARK: - Entity manipulation
    func updatePositions() {
        for entity in entities {
            entity.updatePosition()
        }
    }
}
