//
//  ParallaxBackgroundEntity.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import SpriteKit
import GameplayKit

class ParallaxBackgroundEntity: GlideEntity {
    
    let followCameraComponent: CameraFollowerComponent
    let infiniteSpriteScroller: InfiniteSpriteScrollerComponent
    let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
    let layoutSpriteNodeComponent = SceneAnchoredSpriteLayoutComponent()
    let texture: SKTexture
    
    init(texture: SKTexture,
         widthConstraint: NodeLayoutConstraint,
         heightConstraint: NodeLayoutConstraint,
         yOffsetConstraint: NodeLayoutConstraint,
         cameraFollowMethod: CameraFollowerComponent.PositionUpdateMethod,
         autoScrollSpeed: CGFloat = 0.0) {
        
        self.followCameraComponent = CameraFollowerComponent(positionUpdateMethod: cameraFollowMethod)
        self.infiniteSpriteScroller = InfiniteSpriteScrollerComponent(scrollAxis: .horizontal, autoScrollSpeed: autoScrollSpeed)
        
        self.texture = texture
        
        super.init(initialNodePosition: CGPoint.zero, positionOffset: CGPoint.zero)
        
        layoutSpriteNodeComponent.widthConstraint = widthConstraint
        layoutSpriteNodeComponent.heightConstraint = heightConstraint
        layoutSpriteNodeComponent.yOffsetConstraint = yOffsetConstraint
    }
    
    override func setup() {
        
        transform.usesProposedPosition = false
        
        spriteNodeComponent.spriteNode.texture = texture
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.farBackground
        addComponent(spriteNodeComponent)
        
        addComponent(layoutSpriteNodeComponent)
        
        addComponent(followCameraComponent)
        
        addComponent(infiniteSpriteScroller)
    }
}
