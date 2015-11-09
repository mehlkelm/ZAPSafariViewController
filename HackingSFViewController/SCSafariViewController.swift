//
//  SCSafariViewController.swift
//  HackingSFViewController
//
//  Created by stringCode on 10/10/2015.
//  Copyright © 2015 stringCode. All rights reserved.
//

import UIKit
import SafariServices

public class SCSafariViewController: SFSafariViewController, UIViewControllerTransitioningDelegate {
    let animator = SCModalPushPopAnimator()
    private var _edgeView: UIView?
    
    public override init(URL: NSURL, entersReaderIfAvailable: Bool) {
        super.init(URL: URL, entersReaderIfAvailable: entersReaderIfAvailable)
        self.transitioningDelegate = self
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleGesture:")
        recognizer.edges = UIRectEdge.Left
        if let edgeView = self.edgeView {
            edgeView.addGestureRecognizer(recognizer)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                self.view.bringSubviewToFront(edgeView)
            }
        }
    }
    
    func handleGesture(recognizer:UIScreenEdgePanGestureRecognizer) {
        guard let presentingView = self.presentingViewController?.view else {
            return
        }
        self.animator.percentageDriven = true
        let recognizerPoint = recognizer.locationInView(presentingView)
        let percentComplete = recognizerPoint.x / presentingView.bounds.size.width

        switch recognizer.state {
        case .Began: dismissViewControllerAnimated(true, completion: nil)
        case .Changed: animator.updateInteractiveTransition(percentComplete > 0.99 ? 0.99 : percentComplete)
        case .Ended, .Cancelled:
            (recognizer.velocityInView(view).x < 0) ? animator.cancelInteractiveTransition() : animator.finishInteractiveTransition()
            self.animator.percentageDriven = false
        default: ()
        }
    }
        
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.dismissing = false
        return self.animator
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.dismissing = true
        return self.animator
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.animator.percentageDriven ? self.animator : nil
    }
    
    var edgeView: UIView? {
        get {
            if (_edgeView == nil && isViewLoaded()) {
                _edgeView = UIView()
                _edgeView?.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(_edgeView!)
                _edgeView?.backgroundColor = UIColor(white: 1.0, alpha: 0.005)
                let bindings = ["edgeView": _edgeView!]
                let options = NSLayoutFormatOptions(rawValue: 0)
                let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-0-[edgeView(5)]", options: options, metrics: nil, views: bindings)
                let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[edgeView]-0-|", options: options, metrics: nil, views: bindings)
                view?.addConstraints(hConstraints)
                view?.addConstraints(vConstraints)
            }
            return _edgeView
        }
    }
}