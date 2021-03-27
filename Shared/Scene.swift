//
//  Scene.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import SpriteKit

class Scene: GlideScene {
    
    override func setupScene() {
        shouldPauseWhenAppIsInBackground = false
        backgroundColor = .brown
        addEntity(platformEntity(at: CGPoint(x: 512, y: 50)))
        
        let character = CharacterEntity(initialNodePosition: CGPoint(x: 512, y: 300))
        addEntity(character)
    }
    
    func platformEntity(at position: CGPoint) -> GlideEntity {
        let entity = GlideEntity(initialNodePosition: position)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 640, height: 64))
        spriteNodeComponent.spriteNode.texture = SKTexture(imageNamed: "platform")
        entity.addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(
            categoryMask: GlideCategoryMask.none,
            size: CGSize(width: 100, height: 135),
            offset: .zero,
            leftHitPointsOffsets: (10, 10),
            rightHitPointsOffsets: (10, 10),
            topHitPointsOffsets: (10, 10),
            bottomHitPointsOffsets: (10, 10)
        )
        entity.addComponent(colliderComponent)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: false)
        entity.addComponent(snappableComponent)
        return entity
    }
}
