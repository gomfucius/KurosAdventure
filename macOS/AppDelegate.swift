//
//  AppDelegate.swift
//  KurosAdventure
//
//  Created by Genki Mine on 3/27/21.
//

import Cocoa
import GlideEngine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    static var shared: AppDelegate {
        // swiftlint:disable:next force_cast
        return NSApplication.shared.delegate as! AppDelegate
    }
    var containerViewController: ContainerViewController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        ComponentPriorityRegistry.shared.prettyPrintPriorityList()
        TransformNodeComponent.isDebugEnabled = true
        ColliderComponent.isDebugEnabled = true
        EntityObserverComponent.isDebugEnabled = true
        CheckpointComponent.isDebugEnabled = true
        //CameraComponent.isDebugEnabled = true
        
        containerViewController = NSApplication.shared.windows.first?.contentViewController as? ContainerViewController
        
        let viewModel = LevelSectionsViewModel()
        let titleViewController = TitleViewController(viewModel: viewModel)
        containerViewController?.placeContentViewController(titleViewController)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
