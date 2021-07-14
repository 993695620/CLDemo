//
//  CLCustomTransitionDelegate.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit

class CLCustomTransitionDelegate: NSObject {
    let transition = CLBubbleTransition()
    let interactiveTransition = CLBubbleInteractiveTransition()
    private var bubbleCenter: CGPoint!
    private var bubbleColor: UIColor!
    init(bubbleCenter: CGPoint, bubbleColor: UIColor) {
        self.bubbleCenter = bubbleCenter
        self.bubbleColor = bubbleColor
    }
}
extension CLCustomTransitionDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.bubbleCenter = bubbleCenter
        transition.bubbleColor = bubbleColor
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.bubbleCenter = bubbleCenter
        transition.bubbleColor = bubbleColor
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}
