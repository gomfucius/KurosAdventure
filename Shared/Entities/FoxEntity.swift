//
//  FoxEntity.swift
//

import GlideEngine
import CoreGraphics
import Foundation

class FoxEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 48, height: 25)
    
    init(initialNodePosition: CGPoint) {
        super.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    override func setup() {
        name = "Fox"
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
        addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: KuroCategoryMask.npc,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (10, 10),
                                                  rightHitPointsOffsets: (10, 10),
                                                  topHitPointsOffsets: (15, 15),
                                                  bottomHitPointsOffsets: (5, 5))
        addComponent(colliderComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumHorizontalVelocity = 3.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        var horizontalMovementConfiguration = HorizontalMovementComponent.sharedConfiguration
        horizontalMovementConfiguration.acceleration = 3.0
        horizontalMovementConfiguration.deceleration = 5.0
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .accelerated, configuration: horizontalMovementConfiguration)
        addComponent(horizontalMovementComponent)
        
        let moveComponent = SelfMoveComponent(movementAxes: .horizontal)
        addComponent(moveComponent)
        
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        addComponent(colliderTileHolderComponent)
        
        setupTextureAnimations()
    }
    
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.1
        
        let animationSize = colliderSize
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "fox_idle_%d",
                                                 numberOfFrames: 1,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: .zero,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        
        // Walk
        let walkAction = TextureAnimation.Action(textureFormat: "fox_walk_%d",
                                                 numberOfFrames: 3,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let walkAnimation = TextureAnimation(triggerName: "Walk",
                                             offset: .zero,
                                             size: animationSize,
                                             action: walkAction,
                                             loops: true)
        animatorComponent.addAnimation(walkAnimation)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let kinematicsBody = component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        
        let textureAnimator = component(ofType: TextureAnimatorComponent.self)
        
        if kinematicsBody.velocity.dx < 0 {
            transform.headingDirection = .left
            textureAnimator?.enableAnimation(with: "Walk")
        } else if kinematicsBody.velocity.dx > 0 {
            transform.headingDirection = .right
            textureAnimator?.enableAnimation(with: "Walk")
        } else {
            textureAnimator?.enableAnimation(with: "Idle")
        }
    }
    
}
