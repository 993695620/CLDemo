//
//  CLBubbleTransition.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit

class CLBubbleTransition: NSObject {
    enum BubbleTransitionMode: Int {
        case present, dismiss
    }
    var bubbleCenter: CGPoint = .zero
    var duration = 0.5
    var transitionMode: BubbleTransitionMode = .present
    var bubbleColor: UIColor = .white
}
extension CLBubbleTransition: UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    /**
     Required by UIViewControllerAnimatedTransitioning
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /**
     Required by UIViewControllerAnimatedTransitioning
     */
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        if transitionMode == .present {
            fromViewController?.beginAppearanceTransition(false, animated: true)
            if toViewController?.modalPresentationStyle == .custom {
                toViewController?.beginAppearanceTransition(true, animated: true)
            }
            
            let presentedControllerView = transitionContext.view(forKey: .to)!
            let originalCenter = presentedControllerView.center
            let originalSize = presentedControllerView.frame.size
            
            let bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: bubbleCenter)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = bubbleCenter
            bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            bubble.backgroundColor = bubbleColor
            containerView.addSubview(bubble)
            
            presentedControllerView.center = bubbleCenter
            presentedControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            presentedControllerView.alpha = 0
            containerView.addSubview(presentedControllerView)
            
            UIView.animate(withDuration: duration, animations: {
                bubble.transform = .identity
                presentedControllerView.transform = CGAffineTransform.identity
                presentedControllerView.alpha = 1
                presentedControllerView.center = originalCenter
            }, completion: { (_) in
                transitionContext.completeTransition(true)
                bubble.isHidden = true
                if toViewController?.modalPresentationStyle == .custom {
                    toViewController?.endAppearanceTransition()
                }
                fromViewController?.endAppearanceTransition()
            })
        } else {
            if fromViewController?.modalPresentationStyle == .custom {
                fromViewController?.beginAppearanceTransition(false, animated: true)
            }
            toViewController?.beginAppearanceTransition(true, animated: true)
            
            let returningControllerView = transitionContext.view(forKey: .from)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            
            let bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: bubbleCenter)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.backgroundColor = bubbleColor
            bubble.center = bubbleCenter
            bubble.transform = .identity
            containerView.addSubview(bubble)

            UIView.animate(withDuration: duration, animations: {
                bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.center = self.bubbleCenter
                returningControllerView.alpha = 0
            }, completion: { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
                if !transitionContext.transitionWasCancelled {
                    returningControllerView.center = originalCenter
                    returningControllerView.removeFromSuperview()
                    bubble.removeFromSuperview()
                    
                    if fromViewController?.modalPresentationStyle == .custom {
                        fromViewController?.endAppearanceTransition()
                    }
                    toViewController?.endAppearanceTransition()
                }
            })
        }
    }
}
extension CLBubbleTransition {
    func frameForBubble(_ originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x)
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}

