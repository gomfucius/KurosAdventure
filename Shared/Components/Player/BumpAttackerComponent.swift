//
//  BumpAttackerComponent.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/30/21.
//

import GlideEngine
import GameplayKit

class BumpAttackerComponent: GKComponent, GlideComponent {
    
    func handleNewContact(_ contact: Contact) {
        if let otherCollider = contact.otherObject.colliderComponent {
            
            if otherCollider.categoryMask.rawValue == KuroCategoryMask.npc.rawValue {
                
                if contact.contactSides.contains(.bottom) && contact.otherContactSides?.contains(.top) == true {
                    
                    entity?.component(ofType: BouncerComponent.self)?.bounce(withImpactSides: [.bottom])
                    contact.otherObject.colliderComponent?.entity?.component(ofType: HealthComponent.self)?.applyDamage(1.0)
                }
            }
        }
    }
}
