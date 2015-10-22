//
//  SCAnimator.swift
//  SCUtils
//
//  Created by stringCode on 3/1/15.
//  Copyright (c) 2015 stringCode. All rights reserved.
//

import UIKit

class SCModalPushPopAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    var dismissing = false
    var percentageDriven: Bool = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let topView = dismissing ? fromViewController.view : toViewController.view
        let bottomView = dismissing ? toViewController.view : fromViewController.view
        
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 17.0
        
        transitionContext.containerView()?.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        if dismissing {
            toViewController.view.frame = fromViewController.view.frame
            transitionContext.containerView()?.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        let offset = bottomView.bounds.size.width
        topView.frame = fromViewController.view.frame
        topView.transform = dismissing ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(offset, 0)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            topView.transform = self.dismissing ? CGAffineTransformMakeTranslation(offset, 0) : CGAffineTransformIdentity
            }, completion: { (finished) -> Void in
                topView.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}