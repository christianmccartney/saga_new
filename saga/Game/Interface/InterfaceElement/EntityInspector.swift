//
//  EntityInspector.swift
//  saga
//
//  Created by Christian McCartney on 10/16/21.
//

import Foundation
import SpriteKit
import Combine

class EntityInspector: InterfaceElement {
    private var cancellables = Set<AnyCancellable>()
    private var textTileMap: TextTileMap
    let textColumns: Int
    let textRows: Int
    
    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        self.textColumns = ((columns * STANDARD_TEXTURE_WIDTH) - Int(TEXT_SPRITE_WIDTH * 2)) / Int(TEXT_SPRITE_WIDTH)
        self.textRows = ((columns * STANDARD_TEXTURE_HEIGHT) - Int(TEXT_SPRITE_HEIGHT * 2)) / Int(TEXT_SPRITE_HEIGHT)
        self.textTileMap = TextTileMap(fontType: .dark, columns: textColumns, rows: textRows)
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)
        enableAutomapping = false
        fillSquare(tileSet.tileGroups.first!)
    }
    
    override func attachElements(_ scene: CoreScene) {
        scene.$highlightedEntity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] highlightedEntity in
                guard let self = self else { return }
                self.updateEntity(highlightedEntity)
            }.store(in: &cancellables)
        addChild(textTileMap)
        anchorPoint = CGPoint(x: 0, y: 1.0)
        textTileMap.anchorPoint = CGPoint(x: 0, y: 1.0)
        for element in elements {
            element.attachElements(scene)
        }
    }

    override func setupButtons() {
        
    }

    override func setPosition() {
        posByScreen(x: 0.01, y: 0.99)
    }

    private func updateEntity(_ entity: Entity?) {
        clearText()
        guard let entity = entity else {
            updateText("nothing selected")
            return
        }
        updateText(entity.inspectorDescription(inspectorWidth: textColumns))
    }

    private func updateText(_ text: String) {
        textTileMap.applyString(text, startingAt: Position(1, textTileMap.numberOfRows - 2))
//        addChild(textTileMap)
    }

    private func clearText() {
        textTileMap.clearText()
//        removeChildren(in: [textTileMap])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
