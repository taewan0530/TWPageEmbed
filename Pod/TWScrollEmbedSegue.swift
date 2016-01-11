//
//  TWScrollEmbedControllerSegue.swift
//  TWPageEmbedViewController
//
//  Created by kimtaewan on 2015. 12. 24..
//  Copyright © 2015년 prnd. All rights reserved.
//

import UIKit

public class TWScrollEmbedSegue: UIStoryboardSegue {
    public override func perform() {
        if let sourceViewController = sourceViewController as? TWScrollEmbedController {
            sourceViewController.addEmbedController(destinationViewController)
        } else {
            assertionFailure("SourceViewController must be TWScrollEmbedViewController")
        }
    }
}
