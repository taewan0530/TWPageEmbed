//
//  TWScrollEmbedController.swift
//  TWPageEmbedViewController
//
//  Created by kimtaewan on 2015. 12. 24..
//  Copyright © 2015년 prnd. All rights reserved.
//
import UIKit



open class TWScrollEmbedController: UIViewController {
    
    fileprivate var embedControllers = [UIViewController]()
    
    fileprivate var beforeController: UIViewController?
    open var currentController: UIViewController? {
        return embedControllers[currentPage]
    }
    
    open var initPage: Int = 0
    open var useAnimation: Bool = true
    open var currentPage: Int = 0 {
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
                    UIView.animate(withDuration: 0.3, animations: {
                        scrollView.contentOffset = CGPoint(x: x, y: 0)
                    }, completion: { _ in
                        self.beforeController?.viewDidDisappear(true)
                        self.currentController?.viewDidAppear(true)
                        self.beforeController = self.currentController
                    }) 
                } else {
                    scrollView.contentOffset = CGPoint(x: x, y: 0)
                    beforeController?.viewDidDisappear(false)
                    currentController?.viewDidAppear(false)
                    beforeController = currentController
                }
                
            }
        }//didset
    }
    
    @IBInspectable var embedCount: Int = 0
    @IBOutlet open weak var scrollView: UIScrollView? {
        didSet{
            guard let scrollView = self.scrollView else { return }
            scrollView.delegate = self
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let beforeAnimation = self.useAnimation
        self.useAnimation = false
        initEmbedController()
        self.useAnimation = beforeAnimation
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayouts()
        currentController?.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentController?.viewDidAppear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        currentController?.viewDidDisappear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentController?.viewWillDisappear(animated)
        
    }
    
    open override var shouldAutomaticallyForwardAppearanceMethods : Bool {
        return false
    }
    
    open func addEmbedController(_ controller: UIViewController){
        guard let scrollView = self.scrollView else { return }
        scrollView.layoutIfNeeded()
        
        addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        
        embedControllers.append(controller)
        scrollView.addSubview(controller.view)
        
        updateLayouts()
    }
}


private extension TWScrollEmbedController {
    func initEmbedController(){
        for i in 1...self.embedCount {
            let identifier = "embed-\(i)"
            self.performSegue(withIdentifier: identifier, sender: self)
        }
        
        currentPage = initPage
    }
    
    func updateLayouts(){
        guard let scrollView = self.scrollView else { return }
        
        let len = embedControllers.count
        let width = scrollView.bounds.width
        let height = scrollView.bounds.height
        
        for (idx, controller) in embedControllers.enumerated() {
            controller.view.frame.size = scrollView.bounds.size
            controller.view.frame.origin.x = width * CGFloat(idx)
        }
        
        scrollView.contentSize = CGSize(width: width * CGFloat(len), height: height)
    }
    
}



extension TWScrollEmbedController: UIScrollViewDelegate {
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let controlelr = currentController {
            controlelr.viewDidAppear(useAnimation)
        }
    }
}
