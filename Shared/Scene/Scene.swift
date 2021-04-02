//
//  Scene.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import SpriteKit
import GameplayKit

class Scene: BaseLevelScene {
    
    required init(levelName: String, tileMaps: SceneTileMaps) {
        
        super.init(levelName: levelName, tileMaps: tileMaps)
        
        shouldPauseWhenAppIsInBackground = false
        backgroundColor = .brown
        
        mapContact(between: GlideCategoryMask.player, and: KuroCategoryMask.npc)

        let character = CharacterEntity(initialNodePosition: defaultPlayerStartLocation)
        if let updatableHealthBarComponent = healthBarEntity.component(ofType: UpdatableHealthBarComponent.self) {
            let updateHealthBarComponent = UpdateHealthBarComponent(updatableHealthBarComponent: updatableHealthBarComponent)
            character.addComponent(updateHealthBarComponent)
        }
        addEntity(character)
        addEntity(patrollingWithWallContactNPC(initialNodePosition: TiledPoint(30, 25).point(with: tileSize)))
        addEntity(patrollingWithGapContactNPC(initialNodePosition: TiledPoint(30, 25).point(with: tileSize)))
        addEntity(patrollingWithGapContactNPC(initialNodePosition: TiledPoint(32, 45).point(with: tileSize)))
        addEntity(healthBarEntity)
    }
    
    private func platformEntity(at position: CGPoint) -> GlideEntity {
        let entity = GlideEntity(initialNodePosition: position)
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 640, height: 64))
        spriteNodeComponent.spriteNode.texture = SKTexture(imageNamed: "platform")
        entity.addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(
            categoryMask: GlideCategoryMask.none,
            size: CGSize(width: 640, height: 64),
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
    
    private func patrollingWithWallContactNPC(initialNodePosition: CGPoint) -> GlideEntity {
        let npc = FoxEntity(initialNodePosition: TiledPoint(20, 10).point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .wallContact,
                                                           axes: .horizontal,
                                                           delay: 0.3,
                                                           shouldKinematicsBodyStopOnDirectionChange: false)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        return npc
    }
    
    private func patrollingWithGapContactNPC(initialNodePosition: CGPoint) -> GlideEntity {
        let npc = ImpEntity(initialNodePosition: initialNodePosition)
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let profile = SelfChangeDirectionComponent.Profile(condition: .gapContact,
                                                           axes: .horizontal,
                                                           delay: 0.0,
                                                           shouldKinematicsBodyStopOnDirectionChange: true)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        return npc
    }
    
    private lazy var healthBarEntity: HealthBarEntity = {
        return HealthBarEntity(numberOfHearts: 3)
    }()
}

//
//class Scene: GlideScene {
//    
//    override func setupScene() {
//        shouldPauseWhenAppIsInBackground = false
//        backgroundColor = .brown
//        addEntity(platformEntity(at: CGPoint(x: 512, y: 150)))
//        
//        let character = CharacterEntity(initialNodePosition: CGPoint(x: 200, y: 300))
//        addEntity(character)
//        
//        #if os(iOS)
//        addEntity(moveLeftTouchButtonEntity)
//        addEntity(moveRightTouchButtonEntity)
//        addEntity(jumpTouchButtonEntity)
//        #endif
//    }
//    
//    override func layoutOnScreenItems() {
//        #if os(iOS)
//        layoutTouchControls()
//        #endif
//    }
//
//lazy var moveLeftTouchButtonEntity: GlideEntity = {
//    return touchButtonEntity(name: "Move Left", textureName: "button_left", inputName: "Player1_Horizontal", isNegative: true)
//}()
//
//lazy var moveRightTouchButtonEntity: GlideEntity = {
//    return touchButtonEntity(name: "Move Right", textureName: "button_right", inputName: "Player1_Horizontal", isNegative: false)
//}()
//
//lazy var jumpTouchButtonEntity: GlideEntity = {
//    return touchButtonEntity(name: "Jump", textureName: "button_up", inputName: "Player1_Jump", isNegative: false)
//}()
//
//func touchButtonEntity(name: String, textureName: String, inputName: String, isNegative: Bool) -> GlideEntity {
//    let entity = GlideEntity(initialNodePosition: .zero)
//    entity.name = name
//    entity.transform.usesProposedPosition = false
//
//    let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 120, height: 100))
//    spriteNodeComponent.spriteNode.texture = SKTexture(imageNamed: textureName)
//    spriteNodeComponent.zPositionContainer = GlideZPositionContainer.camera
//    entity.addComponent(spriteNodeComponent)
//
//    let touchButtonComponent = TouchButtonComponent(spriteNode: spriteNodeComponent.spriteNode, input: .profiles([(name: inputName, isNegative: isNegative)]))
//    entity.addComponent(touchButtonComponent)
//    return entity
//}
//
//func layoutTouchControls() {
//    var moveLeftNodeWidth: CGFloat = 0.0
//    if let moveLeftNode = moveLeftTouchButtonEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode {
//        let margin: CGFloat = 30.0
//        let nodePostionX = -size.width / 2 + moveLeftNode.size.width / 2 + margin
//        let nodePostionY = -size.height / 2 + moveLeftNode.size.height / 2 + margin
//        let nodePostion = CGPoint(x: nodePostionX, y: nodePostionY)
//
//        moveLeftTouchButtonEntity.transform.currentPosition = nodePostion
//        moveLeftNodeWidth = moveLeftNode.size.width
//    }
//
//    if let moveRightNode = moveRightTouchButtonEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode {
//        let margin: CGFloat = 30.0
//        let nodePostionX = -size.width / 2 + moveRightNode.size.width / 2 + margin + moveLeftNodeWidth
//        let nodePostionY = -size.height / 2 + moveRightNode.size.height / 2 + margin
//        let nodePostion = CGPoint(x: nodePostionX, y: nodePostionY)
//
//        moveRightTouchButtonEntity.transform.currentPosition = nodePostion
//    }
//
//    if let jumpNode = jumpTouchButtonEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode {
//        let margin: CGFloat = 30.0
//        let nodePositionX = size.width / 2 - jumpNode.size.width / 2 - margin
//        let nodePositionY = -size.height / 2 + jumpNode.size.height / 2 + margin
//        let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
//        jumpTouchButtonEntity.transform.currentPosition = nodePosition
//    }
//}
//
//
//
//}
