//
//  TWScrollEmbedController.swift
//  TWPageEmbedViewController
//
//  Created by kimtaewan on 2015. 12. 24..
//  Copyright © 2015년 prnd. All rights reserved.
//
import UIKit



public class TWScrollEmbedController: UIViewController {
    
    private var embedControllers = [UIViewController]()
    private var currentController: UIViewController?
    
    public var useAnimation: Bool = true
    public var currentPage: Int = 0 {
        willSet {
            guard 0 <= newValue && newValue < embedControllers.count else { return }
            let controlelr = embedControllers[newValue]
            controlelr.viewWillAppear(useAnimation)
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
                
                if useAnimation == false {
                    currentController!.viewDidAppear(false)
                }
            }
        }//didset
    }
    
    @IBInspectable var embedCount: Int = 0
    @IBOutlet public weak var scrollView: UIScrollView? {
        didSet{
            guard let scrollView = self.scrollView else { return }
            scrollView.delegate = self
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.initEmbedController()
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateLayouts()
        if let currentController = self.currentController {
            currentController.viewWillAppear(animated)
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let currentController = self.currentController {
            currentController.viewDidAppear(animated)
        }
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if let currentController = self.currentController {
            currentController.viewDidDisappear(animated)
        }
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentController = self.currentController {
            currentController.viewWillDisappear(animated)
        }
    }
    
    func addEmbedController(controller: UIViewController){
        guard let scrollView = self.scrollView else { return }
        scrollView.layoutIfNeeded()
        
        addChildViewController(controller)
        controller.didMoveToParentViewController(self)
        
        embedControllers.append(controller)
        scrollView.addSubview(controller.view)
        
        self.updateLayouts()
    }
    
    public override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return false
    }
    
    private func initEmbedController(){
        for(var i = 1 ; i <= self.embedCount ; i++){
            let identifier = "embed-\(i)"
            self.performSegueWithIdentifier(identifier, sender: self)
        }
        if currentController == nil && currentPage <= embedControllers.count{
            currentController = embedControllers[currentPage]
        }
    }
    
    private func updateLayouts(){
        guard let scrollView = self.scrollView else { return }
        
        let len = embedControllers.count
        let width = CGRectGetWidth(scrollView.bounds)
        let height = CGRectGetHeight(scrollView.bounds)
        
        for (idx, controller) in embedControllers.enumerate() {
            controller.view.frame.size = scrollView.bounds.size
            controller.view.frame.origin.x = width * CGFloat(idx)
        }
        
        scrollView.contentSize = CGSizeMake(width * CGFloat(len + 1), height)
    }
}

extension TWScrollEmbedController: UIScrollViewDelegate {
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if let controlelr = currentController {
            controlelr.viewDidAppear(useAnimation)
        }
    }
}