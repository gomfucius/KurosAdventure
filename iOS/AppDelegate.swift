//
//  AppDelegate.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import UIKit
import GlideEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        // swiftlint:disable:next force_cast
        return UIApplication.shared.delegate as! AppDelegate
    }
    var window: UIWindow?
    var containerViewController: ContainerViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ComponentPriorityRegistry.shared.prettyPrintPriorityList()
        TransformNodeComponent.isDebugEnabled = true
        ColliderComponent.isDebugEnabled = true
        EntityObserverComponent.isDebugEnabled = true
        CheckpointComponent.isDebugEnabled = true
        //CameraComponent.isDebugEnabled = true
        
        containerViewController = window?.rootViewController as? ContainerViewController
        containerViewController?.loadViewIfNeeded()
        let viewModel = LevelSectionsViewModel()
        let titleViewController = TitleViewController(viewModel: viewModel)
        containerViewController?.placeContentViewController(titleViewController)
        
        return true
    }
}
