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
    
    private var beforeController: UIViewController?
    public var currentController: UIViewController? {
        return embedControllers[currentPage]
    }
    
    public var useAnimation: Bool = true
    public var currentPage: Int = 0 {
        willSet {
            guard 0 <= newValue && newValue < embedControllers.count else { return }
            
            let controlelr = embedControllers[newValue]
            controlelr.viewWillAppear(useAnimation)
            beforeController?.viewWillDisappear(useAnimation)
        }
        didSet {
            if oldValue == currentPage { return }
            currentPage = max(0, min(embedCount - 1, currentPage))
            
            if let scrollView = self.scrollView {
                
                let x = scrollView.frame.size.width * CGFloat(currentPage)
                
                if useAnimation {
                    UIView.animateWithDuration(0.3, animations: {
                        scrollView.contentOffset = CGPointMake(x, 0)
                    }) { _ in
                        self.beforeController?.viewDidDisappear(true)
                        self.currentController?.viewDidAppear(true)
                        self.beforeController = self.currentController
                    }
                } else {
                    scrollView.contentOffset = CGPointMake(x, 0)
                    beforeController?.viewDidDisappear(false)
                    currentController?.viewDidAppear(false)
                    beforeController = currentController
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
        view.setNeedsLayout()
        view.layoutIfNeeded()
        initEmbedController()
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateLayouts()
        currentController?.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        currentController?.viewDidAppear(animated)
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        currentController?.viewDidDisappear(animated)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        currentController?.viewWillDisappear(animated)
        
    }
    
    public override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return false
    }
    
    func addEmbedController(controller: UIViewController){
        guard let scrollView = self.scrollView else { return }
        scrollView.layoutIfNeeded()
        
        addChildViewController(controller)
        controller.didMoveToParentViewController(self)
        
        embedControllers.append(controller)
        scrollView.addSubview(controller.view)
        
        updateLayouts()
    }
}


private extension TWScrollEmbedController {
    func initEmbedController(){
        for i in 1...self.embedCount {
            let identifier = "embed-\(i)"
            self.performSegueWithIdentifier(identifier, sender: self)
        }
        currentPage = 0
    }
    
    func updateLayouts(){
        guard let scrollView = self.scrollView else { return }
        
        let len = embedControllers.count
        let width = CGRectGetWidth(scrollView.bounds)
        let height = CGRectGetHeight(scrollView.bounds)
        
        for (idx, controller) in embedControllers.enumerate() {
            controller.view.frame.size = scrollView.bounds.size
            controller.view.frame.origin.x = width * CGFloat(idx)
        }
        
        scrollView.contentSize = CGSizeMake(width * CGFloat(len), height)
    }
    
}



extension TWScrollEmbedController: UIScrollViewDelegate {
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if let controlelr = currentController {
            controlelr.viewDidAppear(useAnimation)
        }
    }
}