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
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 120, height: 165))
        spriteNodeComponent.spriteNode.texture = SKTexture(imageNamed: "character_walk_0")
        addComponent(spriteNodeComponent) 
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 20
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        let colliderComponent = ColliderComponent(
            categoryMask: GlideCategoryMask.none,
            size: CGSize(width: 100, height: 135),
            offset: .zero,
            leftHitPointsOffsets: (10, 10),
            rightHitPointsOffsets: (10, 10),
            topHitPointsOffsets: (10, 10),
            bottomHitPointsOffsets: (10, 10)
        )
        addComponent(colliderComponent)
        
        let snapperComponent = SnapperComponent()
        addComponent(snapperComponent)
        
        var config = HorizontalMovementComponent.sharedConfiguration
        config.fixedVelocity = 30
        
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .fixedVelocity, configuration: config)
        addComponent(horizontalMovementComponent)
        
        let playableCharacterComponent = PlayableCharacterComponent(playerIndex: 0)
        addComponent(playableCharacterComponent)
        
        setupTextureAnimation()
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
