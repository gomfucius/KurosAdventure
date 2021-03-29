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
//        addEntity(platformEntity(at: CGPoint(x: 512, y: 150)))
//
        let character = CharacterEntity(initialNodePosition: TiledPoint(x: 50, y: 50).point(with: tileSize))
        addEntity(character)
        
//        demo()
    }
    
    enum DemoCategoryMask: UInt32, CategoryMask {
        case enemy = 0xa
        case npc = 0xb
        case projectile = 0xc
        case weapon = 0xd
        case hazard = 0xe
        case itemChest = 0xf
        case chestItem = 0x10
        case crate = 0x11
        case triggerZone = 0x12
        case collectible = 0x13
    }

    enum DemoLightMask: UInt32, LightMask {
        case torch = 0x1
    }

    private func demo() {
        // Initialize your entity in a suitable position of your collidable tile map
        let myEntity = GlideEntity(initialNodePosition: TiledPoint(x: 50, y: 50).point(with: tileSize))

        // Give it a sprite and color it blue
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 24, height: 24))
        // Don't forget to specify a z position for it, if you have a lot of nodes
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.player
        spriteNodeComponent.spriteNode.color = .blue
        myEntity.addComponent(spriteNodeComponent)

        // Make it an entity that can move
        let kinematicsBodyComponent = KinematicsBodyComponent()
        myEntity.addComponent(kinematicsBodyComponent)

        // Make it an entity that can move horizontally
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: MovementStyle.fixedVelocity)
        myEntity.addComponent(horizontalMovementComponent)

        // Make it an entity that can move vertically
        let verticalMovementComponent = VerticalMovementComponent(movementStyle: MovementStyle.fixedVelocity)
        myEntity.addComponent(verticalMovementComponent)

        // Make it a collidable entity
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.chestItem,
                                                  size: CGSize(width: 24, height: 24),
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))
        myEntity.addComponent(colliderComponent)

        // Make it be able to collide with your collidable tile map
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        myEntity.addComponent(colliderTileHolderComponent)

        // Make it playable
        // Use w,a,s,d on keyboard, or direction keys on 🎮 to play with it.
        let playableCharacterComponent = PlayableCharacterComponent(playerIndex: 0)
        myEntity.addComponent(playableCharacterComponent)

        // Add it to the scene
        addEntity(myEntity)
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
