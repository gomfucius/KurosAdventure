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
        backgroundColor = .systemPurple
        
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
