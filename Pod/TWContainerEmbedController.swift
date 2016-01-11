//
//  TWContainerEmbedController.swift
//  TWPageEmbedViewControllerDemo
//
//  Created by kimtaewan on 2016. 1. 11..
//  Copyright © 2016년 prnd. All rights reserved.
//

import Foundation
import UIKit

public class TWContainerEmbedController: UIViewController {
    private var transitionInProgress = false
    
    private var controllerDictionary = [String: UIViewController]()
    private var durationDictionary = [String: CGFloat]()
    
    private var _currentSegueIdentifier: String?
    private var _currentDuration: CGFloat = 0
    
    public var currentSegueIdentifier: String? {
        get {
            return _currentSegueIdentifier
        }
        set {
            if newValue == _currentSegueIdentifier || self.transitionInProgress { return }
            if let identifier = newValue {
                if let toViewController = controllerDictionary[identifier] {
                    self.transitionInProgress = true
                    self._currentDuration = durationDictionary[identifier] ?? 0
                    self.swapFromViewController(self.childViewControllers[0], toViewController: toViewController)
                } else {
                    self.performSegueWithIdentifier(identifier, sender: nil)
                }
            }
            _currentSegueIdentifier = newValue
        }
    }
    
    @IBOutlet weak var containerView: UIView?
    @IBInspectable var initIdentifier: String?

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitionInProgress = false
        if let initIdentifier = self.initIdentifier {
            currentSegueIdentifier = initIdentifier
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let _ = segue as? TWContainerEmbedSegue else {
            super.prepareForSegue(segue, sender: sender)
            return
        }
        
        if 0 == self.childViewControllers.count {
            self.addChildViewController(segue.destinationViewController)
            let destView = segue.destinationViewController.view
            destView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            let parentView = containerTargetView()
            destView.frame = parentView.bounds
            parentView.addSubview(destView)
            segue.destinationViewController.didMoveToParentViewController(self)
        } else {
            guard let identifier = segue.identifier else { return }
            if identifier == currentSegueIdentifier { return }
            self._currentDuration = durationDictionary[identifier] ?? 0
            self.transitionInProgress = true
            self.swapFromViewController(self.childViewControllers[0], toViewController: segue.destinationViewController)
        }
    }
    
    
    private func containerTargetView() -> UIView {
        return self.containerView ?? self.view
    }
}

//MARK - change Controller
extension TWContainerEmbedController {
    
    private func swapFromViewController(fromViewController: UIViewController, toViewController: UIViewController) {
        let parentView = containerTargetView()
        toViewController.view.frame = parentView.bounds
        
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        
        if 0 < self._currentDuration {
            fromViewController.removeFromParentViewController()
            toViewController.didMoveToParentViewController(self)
            self.transitionInProgress = false
        } else {
            let duration: NSTimeInterval = NSTimeInterval(self._currentDuration)
            self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: duration, options: .TransitionCrossDissolve, animations: nil) { (finish: Bool) -> Void in
                fromViewController.removeFromParentViewController()
                toViewController.didMoveToParentViewController(self)
                self.transitionInProgress = false
            }
        }
    }
}

//MARK - addController
extension TWContainerEmbedController {
    
    public func addEmbedControllerChangeDuration(identifier: String , changeDuration: CGFloat = 0){
        durationDictionary[identifier] = changeDuration
    }
    
    public func addEmbedController(identifier: String , viewController: UIViewController, changeDuration: CGFloat = 0){
        controllerDictionary[identifier] = viewController
        durationDictionary[identifier] = changeDuration
    }
}