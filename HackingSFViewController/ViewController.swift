//
//  ViewController.swift
//  HackingSFViewController
//
//  Created by stringCode on 10/10/2015.
//  Copyright © 2015 stringCode. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate, UIViewControllerTransitioningDelegate {
    let animator = SCModalPushPopAnimator()
    
    @IBAction func showSafariViewController(sender: AnyObject) {
        let safariViewController = SCSafariViewController(URL: NSURL(string: "http://zoziapps.ch")!)
        safariViewController.delegate = self;
        self.presentViewController(safariViewController, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

