//
//  ContainerViewControllerMac.swift
//  KurosAdventure
//
//  Created by Genki Mine on 4/2/21.
//

import AppKit
import GameController
import GlideEngine

class ContainerView: NSView {
    // Cursor hiding
    var trackingArea: NSTrackingArea?
    
    override open func updateTrackingAreas() {
        if let trackingArea = trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        if let trackingArea = trackingArea {
            self.addTrackingArea(trackingArea)
        }
    }
    
    override open func mouseMoved(with event: NSEvent) {
        NSCursor.hide()
    }
}

class ContainerViewController: GCEventViewController {
    
    @IBOutlet weak var containerView: View?
    var contentViewController: NSViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentViewController = children.first
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NSCursor.hide()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        contentViewController = children.first
        
        goToFullScreen()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func goToFullScreen() {
        guard let mainScreen = NSScreen.main else {
            return
        }
        
        var presentationOptions = NSApplication.PresentationOptions()
        presentationOptions.insert(.hideDock)
        presentationOptions.insert(.hideMenuBar)
        presentationOptions.insert(.disableAppleMenu)
        presentationOptions.insert(.disableProcessSwitching)
        presentationOptions.insert(.disableSessionTermination)
        presentationOptions.insert(.disableHideApplication)
        presentationOptions.insert(.autoHideToolbar)
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: presentationOptions.rawValue]
        
        self.view.enterFullScreenMode(mainScreen, withOptions: optionsDictionary)
    }
    
    func placeContentViewController(_ viewController: NSViewController) {
        if let contentViewController = contentViewController {
            contentViewController.view.removeFromSuperview()
            contentViewController.removeFromParent()
        }
        
        if let containerView = containerView {
            self.contentViewController = viewController
            addChild(viewController, in: containerView)
        }
    }
    
}
