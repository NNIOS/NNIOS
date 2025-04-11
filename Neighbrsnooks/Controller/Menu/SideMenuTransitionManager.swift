//
//  SideMenuTransitionManager.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 24/07/24.
//

import UIKit

class SideMenuTransitionManager: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning  {

    var isPresenting = false

       func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
           return 0.3
       }

       func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
           guard let toVC = transitionContext.viewController(forKey: isPresenting ? .to : .from) else { return }

           let containerView = transitionContext.containerView
           let screenWidth = UIScreen.main.bounds.width
           let screenHeight = UIScreen.main.bounds.height
           let finalWidth = screenWidth * 0.8

           if isPresenting {
               toVC.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: screenHeight)
               containerView.addSubview(toVC.view)

               UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                   toVC.view.frame = CGRect(x: 0, y: 0, width: finalWidth, height: screenHeight)
               }, completion: { finished in
                   transitionContext.completeTransition(finished)
               })
           } else {
               UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                   toVC.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: screenHeight)
               }, completion: { finished in
                   toVC.view.removeFromSuperview()
                   transitionContext.completeTransition(finished)
               })
           }
       }

       func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           isPresenting = true
           return self
       }

       func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           isPresenting = false
           return self
       }
   }
