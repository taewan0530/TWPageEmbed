//
//  TWPageEmbedViewControllerSegue.swift
//  TWPageEmbedViewController
//
//  Created by kimtaewan on 2015. 12. 24..
//  Copyright © 2015년 prnd. All rights reserved.
//

import UIKit

class TWPageEmbedViewControllerSegue: UIStoryboardSegue {
    
    final override func perform() {
        if let sourceViewController = sourceViewController as? TWPageEmbedViewController {
            sourceViewController.addEmbedController(destinationViewController)
        } else {
            assertionFailure("SourceViewController must be TWPageEmbedViewController")
        }
    }
    
}
