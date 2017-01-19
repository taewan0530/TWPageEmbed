//
//  TWContainerEmbedController.swift
//  TWPageEmbedViewControllerDemo
//
//  Created by kimtaewan on 2016. 1. 11..
//  Copyright © 2016년 prnd. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol TWContainerEmbedControllerDelegate: class {
    @objc optional func willChangeContainerEmbed(_ viewController: UIViewController)
    @objc optional func didChangeContainerEmbed(_ viewController: UIViewController)
}

open class TWContainerEmbedController: UIViewController {
    
    @IBOutlet
    public internal(set) weak var containerView: UIView?
    
    @IBInspectable
    public var initIdentifier: String?
    
    public var changeDuration: CGFloat = 0
    public var transitionOptions: UIViewAnimationOptions = .transitionCrossDissolve
    
    public weak var delegate: TWContainerEmbedControllerDelegate?
    
    public var currentSegueIdentifier: String? {
        didSet {
            guard let identifier = currentSegueIdentifier,
                identifier != oldValue else { return }
            self.performSegue(withIdentifier: identifier, sender: nil)
        }
    }
    
    public internal(set) weak var currentEmbedController: UIViewController?
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let initIdentifier = self.initIdentifier {
            currentSegueIdentifier = initIdentifier
        }
    }
    
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let _ = segue as? TWContainerEmbedSegue else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        self.swap(to: segue.destination)
    }

    
    fileprivate func containerTargetView() -> UIView {
        return self.containerView ?? self.view
    }
}

//MARK - change Controller
extension TWContainerEmbedController {
    
    
    /// 기억해두고 변경해서 쓰고싶다면 이쪽 함수를 태우면 된다!
    ///
    /// - Parameter toViewController:
    public func swap(to viewController: UIViewController) {
        let parentView = containerTargetView()
        guard let fromViewController = currentEmbedController else {
            
            addChildViewController(viewController)
            if let destView = viewController.view {
                let parentView = containerTargetView()
                let bindings = ["view": destView]
                
                destView.frame = parentView.bounds
                parentView.addSubview(destView)
                
                destView.translatesAutoresizingMaskIntoConstraints = false
                parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
                parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
            }
            
            viewController.didMove(toParentViewController: self)
            currentEmbedController = viewController
            return
        }
        
        viewController.view.frame = parentView.bounds
        fromViewController.willMove(toParentViewController: nil)
        addChildViewController(viewController)
        
        
        let duration = TimeInterval(changeDuration)
        delegate?.willChangeContainerEmbed?(viewController)
        transition(from: fromViewController, to: viewController, duration: duration, options: transitionOptions, animations: nil) { (finish: Bool) -> Void in
            fromViewController.removeFromParentViewController()
            viewController.didMove(toParentViewController: self)
            self.delegate?.didChangeContainerEmbed?(viewController)
        }
        
        currentEmbedController = viewController
        
    }
}
