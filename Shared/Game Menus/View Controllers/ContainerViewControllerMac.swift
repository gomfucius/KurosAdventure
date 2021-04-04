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
        
//        goToFullScreen() // Commenting out for debugging purpose
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
        let fadeDuration: TimeInterval = 0.5
        
        func add(animated: Bool) {
            if let containerView = containerView {
                self.contentViewController = viewController
                if animated {
                    // TODO: Animation not working
                    self.addChild(viewController, in: containerView)
                } else {
                    addChild(viewController, in: containerView)
                }
            }
        }
        
        if let contentViewController = contentViewController {
            // swiftlint:disable no_space_in_method_call
            NSAnimationContext.runAnimationGroup { context in
                context.duration = fadeDuration
                contentViewController.view.animator().alphaValue = 0
            } completionHandler: {
                contentViewController.view.alphaValue = 1
                contentViewController.view.removeFromSuperview()
                contentViewController.removeFromParent()
                add(animated: true)
            }
        } else {
            add(animated: false)
        }
    }
    
}
