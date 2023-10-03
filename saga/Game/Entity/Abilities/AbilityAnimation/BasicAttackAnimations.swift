//
//  BasicAttackAnimations.swift
//  saga
//
//  Created by Christian McCartney on 11/14/21.
//

import SpriteKit

let basicAttackAnimation: AbilityAnimation = { caster, target, position, closure in
    let mapController = MapController.shared
    let casterPosition = caster.mapPosition
    let direction: CGPoint
    if let target = target {
        direction = mapController.centerOfTile(target.position.column, target.position.row)
    } else {
        direction = mapController.centerOfTile(position.column, position.row)
    }
    let bopAction = SKAction.move(by: CGVector(dx: (direction.x - casterPosition.x)/2,
                                               dy: (direction.y - casterPosition.y)/2),
                                  duration: 0.125)
    let reverseAction = bopAction.reversed()
    let bopGroup = SKAction.sequence([bopAction, reverseAction])
    let animatedEffect: [AnimatedEffect] = [.slash, .slash2, .cut]
    guard let slashTextures = AnimatedEffect.textures[animatedEffect[Int.random(in: 0...2)]] else {
        fatalError("Failed to get Slash resources")
    }
    let slashNode = Node(texture: slashTextures.first!)
    slashNode.position = direction + CGPoint(x: CGFloat.random(in: -5...5),
                                             y: CGFloat.random(in: -5...5))
    slashNode.zRotation = CGFloat.pi * 0.5
    slashNode.setScale(0.5)
    mapController.addChild(slashNode)
    let animation = SKAction.animate(with: slashTextures, timePerFrame: 0.05)
    slashNode.zPosition = 9
    
    caster.spriteNode.run(bopGroup) {
        slashNode.run(animation) {
            mapController.removeChildren(in: [slashNode])
        }
        closure()
    }
}
