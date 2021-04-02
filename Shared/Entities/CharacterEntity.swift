//
//  CharacterEntity.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import GameplayKit

final class CharacterEntity: GlideEntity {
    
    static let colliderSize = CGSize(width: 28, height: 28)

    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
        spriteNodeComponent.offset = CGPoint(x: 0, y: 0)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.player
        spriteNodeComponent.spriteNode.color = .blue
        addComponent(spriteNodeComponent)

        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.gravity = 60
        kinematicsBodyConfiguration.maximumVerticalVelocity = 20
        kinematicsBodyConfiguration.maximumHorizontalVelocity = 10
        kinematicsBodyConfiguration.metersToScreenPoints = 27
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)

        // Make the player character a collidable entity
        let colliderComponent = ColliderComponent(
            categoryMask: GlideCategoryMask.player,
            size: CharacterEntity.colliderSize,
            offset: .zero,
            leftHitPointsOffsets: (10, 10),
            rightHitPointsOffsets: (10, 10),
            topHitPointsOffsets: (5, 5),
            bottomHitPointsOffsets: (5, 5))
        addComponent(colliderComponent)

        // Make it be able to collide with your collidable tile map
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        addComponent(colliderTileHolderComponent)

        let snapperComponent = SnapperComponent()
        addComponent(snapperComponent)

        let playableCharacterComponent = PlayableCharacterComponent(playerIndex: 0)
        addComponent(playableCharacterComponent)

        let characterComponent = CharacterComponent()
        addComponent(characterComponent)

        var config = HorizontalMovementComponent.sharedConfiguration
        config.acceleration = 80
        config.deceleration = 80
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .accelerated, configuration: config)
        addComponent(horizontalMovementComponent)

        var jumpConfiguration = JumpComponent.sharedConfiguration
        jumpConfiguration.jumpingVelocity = 20
        jumpConfiguration.fasterVerticalVelocityDiff = 1
        jumpConfiguration.serialJumpThreshold = 0.2
        jumpConfiguration.isCornerJumpsEnabled = true
        let jumpComponent = JumpComponent(configuration: jumpConfiguration)
        addComponent(jumpComponent)

        let bumpAttackerComponent = BumpAttackerComponent()
        addComponent(bumpAttackerComponent)

        var bouncerConfiguration = BouncerComponent.sharedConfiguration
        bouncerConfiguration.verticalBouncingVelocity = 16
        bouncerConfiguration.restTimeBetweenBounces = 0.0 // Make it bounceable right away so we can jump on one enemy to another
        let bouncerComponent = BouncerComponent(contactCategoryMasks: KuroCategoryMask.npc, configuration: bouncerConfiguration)
        addComponent(bouncerComponent)

        let healthComponent = HealthComponent(maximumHealth: 3)
        addComponent(healthComponent)

        addComponent(BlinkerComponent(blinkingDuration: 1.0))
        
        setupTextureAnimations()
    }
    
    private func setupTextureAnimations() {
        let animationSize = CGSize(width: 64, height: 64)
        let animationOffset = CGPoint(x: 0, y: 15)
        
        let idleAction = TextureAnimation.Action(textureFormat: "character_walk_%d", numberOfFrames: 4, timePerFrame: 0.45)
        let idleAnimation = TextureAnimation(triggerName: "Idle", offset: animationOffset, size: animationSize, action: idleAction, loops: true)
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        
        let walkAction = TextureAnimation.Action(textureFormat: "character_walk_%d", numberOfFrames: 4, timePerFrame: 0.15)
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
    
    func didSkipUpdate() {
        let isDead = entity?.component(ofType: HealthComponent.self)?.isDead
        let isColliderAlive = entity?.component(ofType: ColliderComponent.self)?.shouldEntityBeUpdated
        if didPlayDieAnimation == false && (isDead == true || isColliderAlive == false) {
            didPlayDieAnimation = true
            entity?.component(ofType: SpriteNodeComponent.self)?.node.removeAllActions()
            entity?.component(ofType: SpriteNodeComponent.self)?.node.run(dieAction, completion: { [weak self] in
                self?.hasDieAnimationFinished = true
            })
        }
    }
    
    // MARK: - Private
    
    private var hasDieAnimationFinished: Bool = false
    private var didPlayDieAnimation: Bool = false
    private let dieAction = SKAction.textureAnimation(textureFormat: "character_die_%d",
                                              numberOfFrames: 7,
                                              timePerFrame: 0.2,
                                              loops: false,
                                              isReverse: false,
                                              textureAtlas: nil,
                                              shouldGenerateNormalMaps: true)
}

extension CharacterComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return hasDieAnimationFinished
    }
}
