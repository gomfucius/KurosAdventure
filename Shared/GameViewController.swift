//
//  GameViewController.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import SpriteKit

final class GameViewController: ViewControllerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = Scene(collisionTileMapNode: nil, zPositionContainers: [])
        scene.scaleMode = .resizeFill
        
        (view as? SKView)?.ignoresSiblingOrder = true
        (view as? SKView)?.presentScene(scene)
    }
}
