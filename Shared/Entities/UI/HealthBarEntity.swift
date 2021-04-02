//
//  HealthBarEntity.swift
//  KurosAdventure
//
//  Created by Genki Mine on 4/1/21.
//

import GlideEngine
import SpriteKit
import GameplayKit

class HealthBarEntity: GlideEntity {
    
    let numberOfHearts: Int
    
    init(numberOfHearts: Int) {
        self.numberOfHearts = numberOfHearts
        super.init(initialNodePosition: .zero, positionOffset: .zero)
    }
    
    override func setup() {
        transform.usesProposedPosition = false
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 120, height: 32))
        spriteNodeComponent.zPositionContainer = GlideZPositionContainer.camera
        spriteNodeComponent.offset = CGPoint(x: 80, y: -36)
        addComponent(spriteNodeComponent)
        
        let healthBarComponent = HealthBarComponent()
        addComponent(healthBarComponent)
        
        let updatableHealthBarComponent = UpdatableHealthBarComponent(numberOfHearts: numberOfHearts) { [weak self] remainingHearts in
            guard let self = self else { return }
            let texture = SKTexture(nearestFilteredImageName: String(format: "hearts_%d", remainingHearts))
            self.component(ofType: SpriteNodeComponent.self)?.spriteNode.texture = texture
        }
        addComponent(updatableHealthBarComponent)
    }
}

class HealthBarComponent: GKComponent, GlideComponent, NodeLayoutableComponent {
    
    func layout(scene: GlideScene, previousSceneSize: CGSize) {
        transform?.currentPosition = CGPoint(x: -scene.size.width / 2, y: scene.size.height / 2)
    }
}
