import UIKit

enum PresentationType {
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}

class AnimatorTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 0.5
    
    private let type: PresentationType
    
    init(type: PresentationType) {
        self.type = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let vc: UIViewController?
        
        if type.isPresenting {
            vc = transitionContext.viewController(forKey: .to)
        } else {
            vc = transitionContext.viewController(forKey: .from)
        }
        
        guard let toVC = vc
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
            
        let currentAlpha: CGFloat = type.isPresenting ? 0 : 1
        let newAlpha: CGFloat = type.isPresenting ? 1 : 0.1
        
        //toVC.view.transform = CGAffineTransform(rotationAngle: .pi)
        toVC.view.transform = CGAffineTransform(scaleX: currentAlpha, y: currentAlpha)
        //toVC.view.alpha = currentAlpha
        
        UIView.animate(withDuration: duration,
                                delay: 0,
                                options: [.curveLinear]) {
            toVC.view.transform = CGAffineTransform(scaleX: newAlpha, y: newAlpha)
            //toVC.view.alpha = newAlpha
        } completion: { (finished) in
            transitionContext.completeTransition(finished)
        }
        
        containerView.addSubview(toVC.view)
    }
}
