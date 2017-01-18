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
    
    @IBOutlet public fileprivate(set) weak var containerView: UIView?
    @IBInspectable var initIdentifier: String?
    
    fileprivate var transitionInProgress = false
    
    fileprivate var controllerDictionary = [String: UIViewController]()
    fileprivate var durationDictionary = [String: CGFloat]()
    
    fileprivate var _currentSegueIdentifier: String?
    fileprivate var _currentDuration: CGFloat = 0
    
    public fileprivate(set) var currentEmbedController: UIViewController? {
        willSet(newController) {
            if let controller = newController {
                delegate?.willChangeContainerEmbed?(controller)
            }
        }
        didSet {
            if let controller = currentEmbedController {
                delegate?.didChangeContainerEmbed?(controller)
            }
        }
    }
    
    
    open var currentSegueIdentifier: String? {
        get {
            return _currentSegueIdentifier
        }
        set {
            if newValue == _currentSegueIdentifier || self.transitionInProgress { return }
            if let identifier = newValue {
                if let toViewController = controllerDictionary[identifier] {
                    self.transitionInProgress = true
                    self._currentDuration = durationDictionary[identifier] ?? 0
                    
                    self.swapFromViewController(toViewController)
                } else {
                    self.performSegue(withIdentifier: identifier, sender: nil)
                }
            }
            _currentSegueIdentifier = newValue
        }
    }
    
    
    
    public weak var delegate: TWContainerEmbedControllerDelegate?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitionInProgress = false
        if let initIdentifier = self.initIdentifier {
            currentSegueIdentifier = initIdentifier
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let _ = segue as? TWContainerEmbedSegue else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        if currentEmbedController != nil {
            guard let identifier = segue.identifier else { return }
            if identifier == currentSegueIdentifier { return }
            self._currentDuration = durationDictionary[identifier] ?? 0
        }
        
        self.transitionInProgress = true
        self.swapFromViewController(segue.destination)
    }
    
    
    fileprivate func containerTargetView() -> UIView {
        return self.containerView ?? self.view
    }
}

//MARK - change Controller
extension TWContainerEmbedController {
    
    
    fileprivate func swapFromViewController(_ toViewController: UIViewController) {
        let parentView = containerTargetView()
        guard let fromViewController = currentEmbedController else {
            
            addChildViewController(toViewController)
            if let destView = toViewController.view {
                //            destView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                let parentView = containerTargetView()
                destView.frame = parentView.bounds
                parentView.addSubview(destView)
                
                //
                destView.translatesAutoresizingMaskIntoConstraints = false
                let bindings = ["view": destView]
                parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
                parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
            }
            //
            toViewController.didMove(toParentViewController: self)
            
            transitionInProgress = false
            currentEmbedController = toViewController
            return
        }
        
        toViewController.view.frame = parentView.bounds
        fromViewController.willMove(toParentViewController: nil)
        self.addChildViewController(toViewController)
        
        if 0 < self._currentDuration {
            fromViewController.removeFromParentViewController()
            toViewController.didMove(toParentViewController: self)
            self.transitionInProgress = false
        } else {
            let duration: TimeInterval = TimeInterval(self._currentDuration)
            self.transition(from: fromViewController, to: toViewController, duration: duration, options: .transitionCrossDissolve, animations: nil) { (finish: Bool) -> Void in
                fromViewController.removeFromParentViewController()
                toViewController.didMove(toParentViewController: self)
                self.transitionInProgress = false
            }
        }
        
        currentEmbedController = toViewController
        
    }
}

//MARK - addController
extension TWContainerEmbedController {
    
    public func addEmbedControllerChangeDuration(_ identifier: String , changeDuration: CGFloat = 0){
        durationDictionary[identifier] = changeDuration
    }
    
    public func addEmbedController(_ identifier: String , viewController: UIViewController, changeDuration: CGFloat = 0){
        controllerDictionary[identifier] = viewController
        durationDictionary[identifier] = changeDuration
    }
    
    public func getEmbedController(_ identifier: String) -> UIViewController? {
        return controllerDictionary[identifier]
    }
}
