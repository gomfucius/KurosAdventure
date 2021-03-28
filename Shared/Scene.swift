//
//  Scene.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import SpriteKit
import GameplayKit

enum DemoZPositionContainer: String, ZPositionContainer, CaseIterable {
    case farBackground
    case background
    case platforms
    case npcs
    case items
    case environment
    case player
    case weapons
    case explosions
    case frontDecoration
    case overlay
}

class BaseLevelScene: GlideScene {
    
    let tileMaps: SceneTileMaps
    var defaultPlayerStartLocation: CGPoint {
        return TiledPoint(10, 10).point(with: tileSize)
    }
    
    lazy var parallaxBackgroundEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_bg_full"),
                                              widthConstraint: .proportionalToSceneSize(1.1),
                                              heightConstraint: .proportionalToSceneSize(1.1),
                                              yOffsetConstraint: .constant(0),
                                              cameraFollowMethod: .linear(horizontalSpeed: -2.0, verticalSpeed: nil))
        return entity
    }()
    
    var inputMethodObservation: Any?
    var conversationDidStartObservation: Any?
    var conversationDidEndObservation: Any?
    var isInConversation: Bool = false
    
    required init(levelName: String, tileMaps: SceneTileMaps) {
        self.tileMaps = tileMaps
        
        super.init(collisionTileMapNode: tileMaps.collisionTileMap, zPositionContainers: DemoZPositionContainer.allCases)
    }
    
    override func setupScene() {
        cameraEntity.component(ofType: CameraComponent.self)?.configuration.fieldOfViewWidth = 3000.0
        
        let groundBackground = tileMaps.decorationTileMaps[0]
        groundBackground.position = collisionTileMapNode?.position ?? .zero
        addChild(groundBackground, in: DemoZPositionContainer.background)
        if tileMaps.decorationTileMaps.count > 1 {
            let frontDecorationBackground = tileMaps.decorationTileMaps[1]
            frontDecorationBackground.position = collisionTileMapNode?.position ?? .zero
            addChild(frontDecorationBackground, in: DemoZPositionContainer.frontDecoration)
        }
        
        addEntity(parallaxBackgroundEntity)
        
        #if os(iOS)
        configureControls()
        
        inputMethodObservation = NotificationCenter.default.addObserver(forName: .InputMethodDidChange, object: nil, queue: nil) { [weak self] _ in
            self?.configureControls()
        }
        
        conversationDidStartObservation = NotificationCenter.default.addObserver(forName: .ConversationDidStart, object: nil, queue: nil) { [weak self] _ in
            self?.isInConversation = true
            self?.configureControls()
        }
        
        conversationDidEndObservation = NotificationCenter.default.addObserver(forName: .ConversationDidEnd, object: nil, queue: nil) { [weak self] _ in
            self?.isInConversation = false
            self?.configureControls()
        }
        #endif
    }
    
    override func layoutOnScreenItems() {
        #if os(iOS)
        layoutTouchControls()
        #endif
    }
    
    #if os(iOS)
    lazy var moveLeftTouchButtonEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Move Left"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 120, height: 100), triggersOnTouchUpInside: false, input: .profiles([(name: "Player1_Horizontal", isNegative: true)]))
        touchButtonComponent.zPositionContainer = GlideZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_moveleft")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_moveleft_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    lazy var moveRightTouchButtonEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Move Right"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 120, height: 100), triggersOnTouchUpInside: false, input: .profiles([(name: "Player1_Horizontal", isNegative: false)]))
        touchButtonComponent.zPositionContainer = GlideZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_moveright")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_moveright_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    lazy var jumpTouchButtonEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Jump"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 120, height: 100), triggersOnTouchUpInside: false, input: .profiles([(name: "Player1_Jump", isNegative: false)]))
        touchButtonComponent.zPositionContainer = GlideZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_jump")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_jump_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    
    var shouldDisplayAdditionalTouchButton: Bool = false {
        didSet {
            if shouldDisplayAdditionalTouchButton {
                if Input.shared.inputMethod.isTouchesEnabled {
                    addEntity(additionalTouchButtonEntity)
                }
            } else {
                removeEntity(additionalTouchButtonEntity)
            }
        }
    }
    
    var shouldDisplaySecondAdditionalTouchButton: Bool = false {
        didSet {
            if shouldDisplaySecondAdditionalTouchButton {
                if Input.shared.inputMethod.isTouchesEnabled {
                    addEntity(secondAdditionalTouchButtonEntity)
                }
            } else {
                removeEntity(secondAdditionalTouchButtonEntity)
            }
        }
    }
    
    lazy var additionalTouchButtonEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Additional Button"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 70, height: 100), triggersOnTouchUpInside: false, input: .callback({}))
        touchButtonComponent.zPositionContainer = GlideZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_empty")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_empty_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    lazy var secondAdditionalTouchButtonEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Second Additional Button"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 70, height: 100), triggersOnTouchUpInside: false, input: .callback({}))
        touchButtonComponent.zPositionContainer = GlideZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_empty")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_empty_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    lazy var pauseButtonEntity: GlideEntity = {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Pause"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 44, height: 44),
                                                        triggersOnTouchUpInside: false,
                                                        input: .callback({ [weak self] in
                                                            self?.isPaused = true
                                                        }))
        touchButtonComponent.zPositionContainer = GlideZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_pause")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_pause_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    
    func configureControls() {
        if Input.shared.inputMethod.isTouchesEnabled && isInConversation == false {
            activateTouchControls()
            layoutTouchControls()
        } else {
            deactivateTouchControls()
        }
    }
    
    func activateTouchControls() {
        addEntity(moveLeftTouchButtonEntity)
        addEntity(moveRightTouchButtonEntity)
        addEntity(jumpTouchButtonEntity)
        if shouldDisplayAdditionalTouchButton {
            addEntity(additionalTouchButtonEntity)
        }
        if shouldDisplaySecondAdditionalTouchButton {
            addEntity(secondAdditionalTouchButtonEntity)
        }
        addEntity(pauseButtonEntity)
    }
    
    func deactivateTouchControls() {
        removeEntity(moveLeftTouchButtonEntity)
        removeEntity(moveRightTouchButtonEntity)
        removeEntity(jumpTouchButtonEntity)
        removeEntity(additionalTouchButtonEntity)
        removeEntity(secondAdditionalTouchButtonEntity)
        removeEntity(pauseButtonEntity)
    }
    
    // swiftlint:disable:next function_body_length
    func layoutTouchControls() {
        if let moveLeftNode = moveLeftTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            let nodePositionX = -size.width / 2 + moveLeftNode.size.width / 2 + 30
            let nodePositionY = -size.height / 2 + moveLeftNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            moveLeftTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        if let moveRightNode = moveRightTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            var moveLeftShift: CGFloat = 0.0
            if let moveLeftNode = moveLeftTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
                moveLeftShift = moveLeftNode.size.width
            }
            let nodePositionX = -size.width / 2 + moveRightNode.size.width / 2 + moveLeftShift + 30
            let nodePositionY = -size.height / 2 + moveRightNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            moveRightTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        if let jumpNode = jumpTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            
            let nodePositionX = size.width / 2 - jumpNode.size.width / 2 - 30
            let nodePositionY = -size.height / 2 + jumpNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            jumpTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        if let additionalButtonNode = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            var jumpShift: CGFloat = 0.0
            if let jumpNode = jumpTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
                jumpShift = jumpNode.size.width + 20
            }
            let nodePositionX = size.width / 2 - additionalButtonNode.size.width / 2 - jumpShift - 30
            let nodePositionY = -size.height / 2 + additionalButtonNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            additionalTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        if let secondAdditionalButtonNode = secondAdditionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            var jumpShift: CGFloat = 0.0
            if let jumpNode = jumpTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
                jumpShift = jumpNode.size.width + 20
            }
            if let additionalButtonNode = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
                jumpShift += additionalButtonNode.size.width + 20
            }
            
            let nodePositionX = size.width / 2 - secondAdditionalButtonNode.size.width / 2 - jumpShift - 30
            let nodePositionY = -size.height / 2 + secondAdditionalButtonNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            secondAdditionalTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        
        if let pauseNode = pauseButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            
            let nodePositionX = size.width / 2 - pauseNode.size.width / 2 - 30
            let nodePositionY = size.height / 2 - pauseNode.size.height / 2 - 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            pauseButtonEntity.transform.proposedPosition = nodePosition
        }
    }
    #endif
    
    deinit {
        if let observation = inputMethodObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = conversationDidStartObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = conversationDidEndObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}

class Scene: BaseLevelScene {
    
    required init(levelName: String, tileMaps: SceneTileMaps) {

        super.init(levelName: levelName, tileMaps: tileMaps)
        
        backgroundColor = .brown
        addEntity(platformEntity(at: CGPoint(x: 512, y: 150)))
        
        let character = CharacterEntity(initialNodePosition: CGPoint(x: 200, y: 300))
        addEntity(character)
        
        demo()
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
        let myEntity = GlideEntity(initialNodePosition: TiledPoint(x: 10, y: 10).point(with: CGSize(width: 16, height: 16) /*scene.tileSize*/))
                
        // Give it a sprite and color it blue
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 24, height: 24))
        // Don't forget to specify a z position for it, if you have a lot of nodes
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
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
    func platformEntity(at position: CGPoint) -> GlideEntity {
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
//    
//    #if os(iOS)
//    let fontSize: CGFloat = 80
//    lazy var moveLeftTouchButtonEntity: GlideEntity = {
//        return touchButtonEntity(name: "Move Left", textureName: "button_left", inputName: "Player1_Horizontal", isNegative: true)
//    }()
//    
//    lazy var moveRightTouchButtonEntity: GlideEntity = {
//        return touchButtonEntity(name: "Move Right", textureName: "button_right", inputName: "Player1_Horizontal", isNegative: false)
//    }()
//    
//    lazy var jumpTouchButtonEntity: GlideEntity = {
//        return touchButtonEntity(name: "Jump", textureName: "button_up", inputName: "Player1_Jump", isNegative: false)
//    }()
//    
//    func touchButtonEntity(name: String, textureName: String, inputName: String, isNegative: Bool) -> GlideEntity {
//        let entity = GlideEntity(initialNodePosition: .zero)
//        entity.name = name
//        entity.transform.usesProposedPosition = false
//        
//        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 120, height: 100))
//        spriteNodeComponent.spriteNode.texture = SKTexture(imageNamed: textureName)
//        spriteNodeComponent.zPositionContainer = GlideZPositionContainer.camera
//        entity.addComponent(spriteNodeComponent)
//        
//        let touchButtonComponent = TouchButtonComponent(spriteNode: spriteNodeComponent.spriteNode, input: .profiles([(name: inputName, isNegative: isNegative)]))
//        entity.addComponent(touchButtonComponent)
//        return entity
//    }
//    
//    func layoutTouchControls() {
//        var moveLeftNodeWidth: CGFloat = 0.0
//        if let moveLeftNode = moveLeftTouchButtonEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode {
//            let margin: CGFloat = 30.0
//            let nodePostionX = -size.width / 2 + moveLeftNode.size.width / 2 + margin
//            let nodePostionY = -size.height / 2 + moveLeftNode.size.height / 2 + margin
//            let nodePostion = CGPoint(x: nodePostionX, y: nodePostionY)
//
//            moveLeftTouchButtonEntity.transform.currentPosition = nodePostion
//            moveLeftNodeWidth = moveLeftNode.size.width
//        }
//        
//        if let moveRightNode = moveRightTouchButtonEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode {
//            let margin: CGFloat = 30.0
//            let nodePostionX = -size.width / 2 + moveRightNode.size.width / 2 + margin + moveLeftNodeWidth
//            let nodePostionY = -size.height / 2 + moveRightNode.size.height / 2 + margin
//            let nodePostion = CGPoint(x: nodePostionX, y: nodePostionY)
//
//            moveRightTouchButtonEntity.transform.currentPosition = nodePostion
//        }
//        
//        if let jumpNode = jumpTouchButtonEntity.component(ofType: SpriteNodeComponent.self)?.spriteNode {
//            let margin: CGFloat = 30.0
//            let nodePositionX = size.width / 2 - jumpNode.size.width / 2 - margin
//            let nodePositionY = -size.height / 2 + jumpNode.size.height / 2 + margin
//            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
//            jumpTouchButtonEntity.transform.currentPosition = nodePosition
//        }
//    }
//    #endif
//}
