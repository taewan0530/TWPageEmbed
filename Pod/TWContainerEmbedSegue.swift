//
//  TWContainerEmbedSegue.swift
//  TWPageEmbedViewControllerDemo
//
//  Created by kimtaewan on 2016. 1. 11..
//  Copyright © 2016년 prnd. All rights reserved.
//

import Foundation
import UIKit

open class TWContainerEmbedSegue: UIStoryboardSegue {
        
    open override func perform() {
        guard let containerEmbedController = self.source as? TWContainerEmbedController else {
            assertionFailure("SourceViewController must be TWContainerEmbedController")
            return
        }
        guard let identifier = identifier else {
            assertionFailure("TWContainerEmbedSegue must have identifier")
            return
        }
    }
}

