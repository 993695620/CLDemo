//
//  CLBubbleTransition.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit

class CLBubbleTransition: NSObject {
    
    /**
     The point that originates the bubble. The bubble starts from this point
     and shrinks to it on dismiss
     */
    @objc open var bubbleCenter: CGPoint = .zero {
        didSet {
            bubble.center = bubbleCenter
        }
    }
    
    /**
     The transition duration. The same value is used in both the Present or Dismiss actions
     Defaults to `0.5`
     */
    @objc open var duration = 0.5
    
    /**
     The transition direction. Possible values `.present`, `.dismiss` or `.pop`
     Defaults to `.Present`
     */
    @objc open var transitionMode: BubbleTransitionMode = .present
    
    /**
     The color of the bubble. Make sure that it matches the destination controller's background color.
     */
    @objc open var bubbleColor: UIColor = .white
    
    open fileprivate(set) var bubble = UIView()
    
    /**
     The possible directions of the transition.
     
     - Present: For presenting a new modal controller
     - Dismiss: For dismissing the current controller
     - Pop: For a pop animation in a navigation controller
     */
    @objc public enum BubbleTransitionMode: Int {
        case present, dismiss, pop
    }
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
            
            bubble = UIView()
            bubble.clipsToBounds = true
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
                self.bubble.transform = .identity
                presentedControllerView.transform = CGAffineTransform.identity
                presentedControllerView.alpha = 1
                presentedControllerView.center = originalCenter
            }, completion: { (_) in
                transitionContext.completeTransition(true)
                self.bubble.isHidden = true
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
            
            let key: UITransitionContextViewKey = (transitionMode == .pop) ? .to : .from
            let returningControllerView = transitionContext.view(forKey: key)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            
            bubble = UIView()
            bubble.clipsToBounds = true
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: bubbleCenter)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.backgroundColor = bubbleColor
            bubble.center = bubbleCenter
            bubble.transform = .identity
            containerView.addSubview(bubble)

            UIView.animate(withDuration: duration, animations: {
                self.bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.center = self.bubbleCenter
                returningControllerView.alpha = 0
                
                if self.transitionMode == .pop {
                    containerView.insertSubview(returningControllerView, belowSubview: returningControllerView)
                    containerView.insertSubview(self.bubble, belowSubview: returningControllerView)
                }
            }, completion: { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
                if !transitionContext.transitionWasCancelled {
                    returningControllerView.center = originalCenter
                    returningControllerView.removeFromSuperview()
                    self.bubble.removeFromSuperview()
                    
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

