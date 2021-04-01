//
//  ImpEntity.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/30/21.
//

import GlideEngine
import CoreGraphics
import GameplayKit

class ImpEntity: GlideEntity {
    
    let colliderSize = CGSize(width: 20, height: 36)
    
    init(initialNodePosition: CGPoint) {
        super.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    override func setup() {
        name = "Imp"
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
        addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: KuroCategoryMask.npc,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (10, 10),
                                                  rightHitPointsOffsets: (10, 10),
                                                  topHitPointsOffsets: (5, 5),
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
        
        addComponent(ImpComponent())
        addComponent(HealthComponent(maximumHealth: 1.0))
        addComponent(HazardComponent())
        
        setupTextureAnimations()
    }
    
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.1
        
        let animationSize = CGSize(width: 45, height: 41)
        let animationOffset = CGPoint(x: 0, y: 3)
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "imp_idle_%d",
                                                 numberOfFrames: 1,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: animationOffset,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        
        // Walk
        let walkAction = TextureAnimation.Action(textureFormat: "imp_walk_%d",
                                                 numberOfFrames: 4,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let walkAnimation = TextureAnimation(triggerName: "Walk",
                                             offset: animationOffset,
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

class ImpComponent: GKComponent, GlideComponent {
    
    var hasDieAnimationFinished: Bool = false
    var didPlayDieAnimation: Bool = false
    
    let dieAction = SKAction.textureAnimation(textureFormat: "eagle_die_%d",
                                              numberOfFrames: 11,
                                              timePerFrame: 0.15,
                                              loops: false,
                                              isReverse: false,
                                              textureAtlas: nil,
                                              shouldGenerateNormalMaps: true)
    
    func didSkipUpdate() {
        let isDead = entity?.component(ofType: HealthComponent.self)?.isDead
        if didPlayDieAnimation == false && isDead == true {
            didPlayDieAnimation = true
            entity?.component(ofType: SpriteNodeComponent.self)?.node.removeAllActions()
            entity?.component(ofType: SpriteNodeComponent.self)?.node.run(dieAction, completion: { [weak self] in
                self?.hasDieAnimationFinished = true
            })
        }
    }
}

extension ImpComponent: RemovalControllingComponent {
    
    public var canEntityBeRemoved: Bool {
        return hasDieAnimationFinished
    }
    
}

