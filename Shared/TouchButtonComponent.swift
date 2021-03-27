//
//  TouchButtonComponent.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import SpriteKit
import GameplayKit

final class TouchButtonComponent: GKComponent, GlideComponent, TouchReceiverComponent {
   
    // MARK: - TouchReceiverComponent
    
    var hitBoxNode: SKSpriteNode
    
    var currentTouchCount: Int = 0
    
    var isHighlighted: Bool = false
    
    var triggersOnTouchUpInside: Bool = false
    
    var input: TouchInputProfilesOrCallback
    
    init(spriteNode: SKSpriteNode, input: TouchInputProfilesOrCallback) {
        self.hitBoxNode = spriteNode
        self.input = input
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
