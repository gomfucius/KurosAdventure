//
//  GameViewController.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import GlideEngine
import SpriteKit

class LoadingScene: SKScene {
    override func sceneDidLoad() {
        backgroundColor = .red
    }
}

class BlankScene: SKScene {
    override func sceneDidLoad() {
        backgroundColor = .white
    }
}

final class GameViewController: ViewControllerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.view as? SKView)?.presentScene(BlankScene())
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.displayLevel(decorationTilesAtlas: nil)
        }
    }
    
    override func loadView() {
        // Don't call super.loadView(), it'll crash due to nib not found
        self.view = SKView()
        #if os(iOS)
        self.view.isMultipleTouchEnabled = true
        #endif
    }

    // MARK: - Private
    
    private var scene: BaseLevelScene?
    private var overlayViewController: NavigatableViewController?
    
    private func displayLevel(decorationTilesAtlas: SKTextureAtlas? = SKTextureAtlas(named: "Decoration Tiles Platform Grass Rock")) {
        let loader = TiledMapEditorSceneLoader(fileName: "TestMap",
                                               bundle: Bundle.main,
                                               collisionTilesTextureAtlas: decorationTilesAtlas,
                                               decorationTilesTextureAtlas: nil)
        guard let tileMaps = loader.tileMaps else {
            fatalError("Couldn't load the level file")
        }

        let scene = Scene(levelName: "First", tileMaps: tileMaps)
        scene.glideSceneDelegate = self
        scene.scaleMode = .resizeFill
        self.scene = scene
        
        guard let view = self.view as? SKView else {
            return
        }
        
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif
        
        view.ignoresSiblingOrder = true
        let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5) // Not working yet
        view.presentScene(scene, transition: reveal)
    }
    
    private func loadTextureAtlases(for level: Level?) {
        let decorationTilesAtlas = SKTextureAtlas(named: "Decoration Tiles Platform Grass Rock")
        
        SKTextureAtlas.preloadTextureAtlases([decorationTilesAtlas]) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.displayLevel(decorationTilesAtlas: SKTextureAtlas(named: "Decoration Tiles Platform Grass Rock"))
            }
        }
    }
    
    private func displayPauseMenu(on scene: GlideScene, displaysResume: Bool) {
        guard overlayViewController == nil else {
            return
        }
        
        let pauseViewController = PauseMenuViewController(displaysResume: displaysResume)
        self.overlayViewController = pauseViewController
        pauseViewController.delegate = self
        addChild(pauseViewController)
        pauseViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseViewController.view)
        NSLayoutConstraint.activate([
            pauseViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pauseViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pauseViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pauseViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        pauseViewController.cancelHandler = { [weak self] _ in
            self?.hidePauseMenu()
            scene.isPaused = false
        }
    }
    
    private func hidePauseMenu() {
        if let overlay = overlayViewController, overlay is PauseMenuViewController {
            overlay.view.removeFromSuperview()
            overlay.removeFromParent()
            self.overlayViewController = nil
        }
    }
}

// MARK: - GlideSceneDelegate

extension GameViewController: GlideSceneDelegate {
    
    func glideScene(_ scene: GlideScene, didChangePaused paused: Bool) {
        if paused {
            displayPauseMenu(on: scene, displaysResume: true)
        } else {
            hidePauseMenu()
        }
    }
    
    func glideSceneDidEnd(_ scene: GlideScene, reason: GlideScene.EndReason?, context: [String: Any]?) {
        scene.isPaused = true
        displayPauseMenu(on: scene, displaysResume: false)
    }
    
    func removeOverlay() {
        overlayViewController?.removeFromParent()
        overlayViewController?.view.removeFromSuperview()
        overlayViewController = nil
    }
}

// MARK: - PauseMenuViewControllerDelegate

extension GameViewController: PauseMenuViewControllerDelegate {
    func pauseMenuViewControllerDidSelectResume(_ pauseMenuViewController: PauseMenuViewController) {
        removeOverlay()
        
        scene?.isPaused = false
    }
    
    func pauseMenuViewControllerDidSelectRestart(_ pauseMenuViewController: PauseMenuViewController) {
        removeOverlay()
        
        loadTextureAtlases(for: nil) // update this level
    }
    
    func pauseMenuViewControllerDidSelectMainMenu(_ pauseMenuViewController: PauseMenuViewController) {

//        let viewModel = LevelSectionsViewModel()
//        let levelSectionsViewController = LevelSectionsViewController(viewModel: viewModel)
//        AppDelegate.shared.containerViewController?.placeContentViewController(levelSectionsViewController)
    }
}
