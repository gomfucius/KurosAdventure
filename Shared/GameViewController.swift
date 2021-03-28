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
        
        loadTiledMapEditor()
    }
    
    private func loadSKS() {
        // Load a SKScene with your scene file.
        let sks = SKScene(fileNamed: "MyScene")
        guard let collisionTileMap = sks?.childNode(withName: "CollidableGround") as? SKTileMapNode else {
            fatalError("Couldn't load the collision tile map")
        }
        var decorationTileMaps: [SKTileMapNode] = []
        // Remove nodes from loaded scene to prevent double parent crash.
        if let decorationTileMap = sks?.childNode(withName: "Decoration") as? SKTileMapNode {
            decorationTileMap.removeFromParent()
            decorationTileMaps.append(decorationTileMap)
        }
        collisionTileMap.removeFromParent()
        let tileMaps = SceneTileMaps(collisionTileMap: collisionTileMap, decorationTileMaps: decorationTileMaps)

        // Create your scene
        let scene = Scene(levelName: "First", tileMaps: tileMaps)

        /// Add your decoration tile maps in appropriate z position container nodes.
        /// e.g. addChild(frontDecorationBackground, in: DemoZPositionContainer.frontDecoration)
        /// Alternatively, do this in a custom `GlideScene` subclass.
        scene.scaleMode = .resizeFill

        /// Then present your scene
        (view as? SKView)?.presentScene(scene)
    }
    
    private func loadTiledMapEditor() {
        //        let scene = Scene(collisionTileMapNode: nil, zPositionContainers: [])
        let decorationTilesAtlas = SKTextureAtlas(named: "Decoration Tiles")

        let loader = TiledMapEditorSceneLoader(fileName: "TestMap",
                                               bundle: Bundle.main,
                                               collisionTilesTextureAtlas: decorationTilesAtlas,
                                               decorationTilesTextureAtlas: nil)
        guard let tileMaps = loader.tileMaps else {
            fatalError("Couldn't load the level file")
        }

        // Create your scene
        let scene = Scene(levelName: "First", tileMaps: tileMaps)
        /// Add your decoration tile maps in appropriate z position container nodes.
        /// e.g. addChild(frontDecorationBackground, in: DemoZPositionContainer.frontDecoration)
        /// Alternatively, do this in a custom `GlideScene` subclass.
        scene.scaleMode = .resizeFill

        /// Then present your scene
        (view as? SKView)?.ignoresSiblingOrder = true
        (view as? SKView)?.presentScene(scene)
    }
}
