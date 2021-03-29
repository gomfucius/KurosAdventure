//
//  CharacterEntity.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import GameplayKit

final class CharacterEntity: GlideEntity {
    
    override func setup() {
//        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 16, height: 16))
//        spriteNodeComponent.spriteNode.texture = SKTexture(imageNamed: "character_walk_0")
//        addComponent(spriteNodeComponent)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 24, height: 24))
        // Don't forget to specify a z position for it, if you have a lot of nodes
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.player
        spriteNodeComponent.spriteNode.color = .blue
        addComponent(spriteNodeComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 20
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        // Make it a collidable entity
        let colliderComponent = ColliderComponent(
            categoryMask: GlideCategoryMask.none,
            size: CGSize(width: 24, height: 24),
            offset: .zero,
            leftHitPointsOffsets: (5, 5),
            rightHitPointsOffsets: (5, 5),
            topHitPointsOffsets: (5, 5),
            bottomHitPointsOffsets: (5, 5))
        addComponent(colliderComponent)

        // Make it be able to collide with your collidable tile map
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        addComponent(colliderTileHolderComponent)
        
        let snapperComponent = SnapperComponent()
        addComponent(snapperComponent)
        
        var config = HorizontalMovementComponent.sharedConfiguration
        config.fixedVelocity = 15
        
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .fixedVelocity, configuration: config)
        addComponent(horizontalMovementComponent)
        
        let playableCharacterComponent = PlayableCharacterComponent(playerIndex: 0)
        addComponent(playableCharacterComponent)
        
//        setupTextureAnimation()
        let characterComponent = CharacterComponent()
        addComponent(characterComponent)
        
        var jumpConfiguration = JumpComponent.sharedConfiguration
        jumpConfiguration.jumpingVelocity = 16
        let jumpComponent = JumpComponent(configuration: jumpConfiguration)
        addComponent(jumpComponent)
    }
    
    private func setupTextureAnimation() {
        let timePerFrame: TimeInterval = 0.15
        let animationSize = CGSize(width: 120, height: 165)
        let animationOffset = CGPoint(x: 0, y: 15)
        
        let idleAction = TextureAnimation.Action(textureFormat: "character_walk_%d", numberOfFrames: 1, timePerFrame: timePerFrame)
        let idleAnimation = TextureAnimation(triggerName: "Idle", offset: animationOffset, size: animationSize, action: idleAction, loops: true)
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        
        let walkAction = TextureAnimation.Action(textureFormat: "character_walk_%d", numberOfFrames: 3, timePerFrame: timePerFrame)
        let walkAnimation = TextureAnimation(triggerName: "Walk", offset: animationOffset, size: animationSize, action: walkAction, loops: true)
        animatorComponent.addAnimation(walkAnimation)
    }
    
}

final class CharacterComponent: GKComponent, GlideComponent {
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        let horizontalMovementComponent = entity?.component(ofType: HorizontalMovementComponent.self)
        let textureAnimatorComponent = entity?.component(ofType: TextureAnimatorComponent.self)
        
        if horizontalMovementComponent?.movementDirection != .stationary {
            textureAnimatorComponent?.enableAnimation(with: "Walk")
        } else {
            textureAnimatorComponent?.enableAnimation(with: "Idle")
        }
    }
}
