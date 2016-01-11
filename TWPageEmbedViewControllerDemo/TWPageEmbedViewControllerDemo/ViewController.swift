//
//  ViewController.swift
//  TWPageEmbedViewControllerDemo
//
//  Created by kimtaewan on 2015. 12. 24..
//  Copyright © 2015년 prnd. All rights reserved.
//

import UIKit

class ViewController: TWContainerEmbedController {

//    var containerEmbedController: TWContainerEmbedController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentSegueIdentifier = "first"

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapFirst(sender: AnyObject) {
        self.currentSegueIdentifier = "first"
    }

    @IBAction func tapSecound(sender: AnyObject) {
        self.currentSegueIdentifier = "secound"
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        super.prepareForSegue(segue, sender: sender)
//        if segue.identifier == "container" {
//            print("!@!@!")
//            self.containerEmbedController = segue.destinationViewController as? TWContainerEmbedController
//        }
//    }
}

