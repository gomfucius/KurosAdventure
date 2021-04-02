//
//  ContainerViewController.swift
//  KurosAdventure
//
//  Created by Genki Mine on 4/2/21.
//

import GlideEngine
import GameController

class ContainerViewController: GCEventViewController {
    
    @IBOutlet weak var containerView: View?
    var contentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentViewController = children.first
    }
    
    func placeContentViewController(_ viewController: UIViewController) {
        if let contentViewController = contentViewController {
            contentViewController.view.removeFromSuperview()
            contentViewController.removeFromParent()
        }
        
        if let containerView = containerView {
            self.contentViewController = viewController
            addChild(viewController, in: containerView)
        }
    }
    
    #if os(iOS)
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }
    #endif
    
}
