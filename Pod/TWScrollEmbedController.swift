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
        didSet{
            currentPage = max(0, min(embedCount - 1, currentPage))
            
            if let scrollView = self.scrollView {
                var frame = scrollView.frame
                frame.origin.x = frame.size.width * CGFloat(currentPage)
                
                if currentPage <= embedControllers.count{
                    currentController = embedControllers[currentPage]
                }
                
                scrollView.scrollRectToVisible(frame, animated: useAnimation)
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
    
    func addEmbedController(controller: UIViewController){
        if let scrollView = self.scrollView {
            let idx = CGFloat(embedControllers.count)
            
            embedControllers.append(controller)
            self.addChildViewController(controller)
            
            
            controller.view.frame.size = scrollView.frame.size
            controller.view.frame.origin.x = scrollView.frame.size.width * idx
            
            scrollView.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
            
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * (idx+1), scrollView.frame.size.height)
        }
    }
    
    private func initEmbedController(){
        for(var i = 1 ; i <= self.embedCount ; i++){
            let identifier = "embed-\(i)"
            self.performSegueWithIdentifier(identifier, sender: self)
        }
    }
    
}