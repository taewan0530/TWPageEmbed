//
//  TWScrollEmbedControllerSegue.swift
//  TWPageEmbedViewController
//
//  Created by kimtaewan on 2015. 12. 24..
//  Copyright © 2015년 prnd. All rights reserved.
//

import UIKit

open class TWScrollEmbedSegue: UIStoryboardSegue {
    open override func perform() {
        if let sourceViewController = source as? TWScrollEmbedController {
            sourceViewController.addEmbedController(destination)
        } else {
            assertionFailure("SourceViewController must be TWScrollEmbedViewController")
        }
    }
}
