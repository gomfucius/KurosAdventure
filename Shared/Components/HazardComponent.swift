//
//  HazardComponent.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/31/21.
//

import GameplayKit
import GlideEngine

class HazardComponent: GKComponent, GlideComponent {
    
    /// If hit from left or right, damage the player
    func handleNewContact(_ contact: Contact) {
        if let otherCollider = contact.otherObject.colliderComponent {
            if otherCollider.categoryMask.rawValue == GlideCategoryMask.player.rawValue {
                if contact.contactSides.contains(.left) || contact.contactSides.contains(.right) {
                    contact.otherObject.colliderComponent?.entity?.component(ofType: HealthComponent.self)?.applyDamage(1)
                }
            }
        }
    }
    
}
