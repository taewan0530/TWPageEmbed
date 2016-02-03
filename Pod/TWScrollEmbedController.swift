//
//  TWScrollEmbedController.swift
//  TWPageEmbedViewController
//
//  Created by kimtaewan on 2015. 12. 24..
//  Copyright © 2015년 prnd. All rights reserved.
//


import UIKit

@objc
public protocol TWScrollEmbedControllerDelegate {
    optional func willScrollShowController()
    optional func didScrollShowController()
}

public class TWScrollEmbedController: UIViewController {
    
    private var embedControllers = [UIViewController]()
    private var currentController: UIViewController?
    
    public var useAnimation: Bool = true
    public var currentPage: Int = 0 {
        willSet {
            guard 0 <= newValue && newValue < embedControllers.count else { return }
            let controlelr = embedControllers[newValue]
            if let delegate = controlelr as? TWScrollEmbedControllerDelegate {
                delegate.willScrollShowController?()
            }
        }
        didSet {
            currentPage = max(0, min(embedCount - 1, currentPage))
            
            if let scrollView = self.scrollView {
                var frame = scrollView.frame
                frame.origin.x = frame.size.width * CGFloat(currentPage)
                
                if currentPage <= embedControllers.count{
                    currentController = embedControllers[currentPage]
                }
                
                scrollView.scrollRectToVisible(frame, animated: useAnimation)
                if let delegate = currentController as? TWScrollEmbedControllerDelegate {
                    delegate.didScrollShowController?()
                }
            }
        }//didset
    }
    
    @IBInspectable var embedCount: Int = 0
    @IBOutlet public weak var scrollView: UIScrollView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.initEmbedController()
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateLayouts()
    }
    
    func addEmbedController(controller: UIViewController){
        guard let scrollView = self.scrollView else { return }
        
        embedControllers.append(controller)
        self.addChildViewController(controller)
        
        scrollView.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        
        self.updateLayouts()
    }
    
    private func initEmbedController(){
        for(var i = 1 ; i <= self.embedCount ; i++){
            let identifier = "embed-\(i)"
            self.performSegueWithIdentifier(identifier, sender: self)
        }
    }
    
    private func updateLayouts(){
        guard let scrollView = self.scrollView else { return }
        
        let len = embedControllers.count
        let width = CGRectGetWidth(scrollView.bounds)
        let height = CGRectGetHeight(scrollView.bounds)
        
        for (idx, controller) in embedControllers.enumerate() {
            controller.view.bounds.size = scrollView.bounds.size
            controller.view.frame.origin.x = width * CGFloat(idx)
        }
        
        scrollView.contentSize = CGSizeMake(width * CGFloat(len + 1), height)
    }
    
}