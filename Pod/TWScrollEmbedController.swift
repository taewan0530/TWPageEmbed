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
    private(set) var currentController: UIViewController?
    
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
        view.setNeedsLayout()
        view.layoutIfNeeded()
        initEmbedController()
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateLayouts()
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