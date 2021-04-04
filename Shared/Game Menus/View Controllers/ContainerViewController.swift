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
        func add(animated: Bool) {
            if let containerView = containerView {
                self.contentViewController = viewController
                if animated {
                    UIView.animate(withDuration: 0.5) {
                        self.addChild(viewController, in: containerView)
                    }
                } else {
                    addChild(viewController, in: containerView)
                }
            }
        }
        
        if let contentViewController = contentViewController {
            UIView.animate(withDuration: 0.5, animations: {
                contentViewController.view.alpha = 0.0
            }, completion: { _ in
                contentViewController.view.removeFromSuperview()
                contentViewController.removeFromParent()
                add(animated: true)
            })
        } else {
            add(animated: false)
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
