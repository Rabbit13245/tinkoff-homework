import UIKit

enum PresentationType {
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}

class AnimatorTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 0.3
    
    private let type: PresentationType
    
    init(type: PresentationType) {
        self.type = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let isPresenting = type.isPresenting
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        guard let fromNavVC = transitionContext.viewController(forKey: .from) as? UINavigationController,
              let toNavVC = transitionContext.viewController(forKey: .to) as? UINavigationController,
              let window = fromNavVC.view.window
        else {
            transitionContext.completeTransition(true)
            return
        }
        if isPresenting {
            guard let fromVC = fromNavVC.viewControllers.first as? ChannelsListViewController,
                  let toVc = toNavVC.viewControllers.first as? ProfileViewController,
                  let image = fromVC.profileBarButton.customView
            else {
                transitionContext.completeTransition(true)
                return
            }
            containerView.addSubview(toNavVC.view)
            
            let miniImageFrame = image.convert(image.bounds, to: window)
            let bigFrame = toNavVC.view.convert(toNavVC.view.bounds, to: window)
            
            let scale = (miniImageFrame.maxX - miniImageFrame.minX) / (bigFrame.maxX - bigFrame.minX)
            
            toNavVC.view.layer.position = CGPoint(x: miniImageFrame.midX, y: miniImageFrame.midY)
            toNavVC.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            toNavVC.view.alpha = 0
            
            let hideTransform = CGAffineTransform(translationX: toVc.view.bounds.width, y: 0)
            toVc.gcdSaveButton.transform = hideTransform
            toVc.operationSaveButton.transform = hideTransform
            toVc.nameTextView.transform = hideTransform
            toVc.descriptionTextView.transform = hideTransform
            
            UIView.animateKeyframes(withDuration: duration,
                                    delay: 0,
                                    options: [.calculationModeLinear]) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    toNavVC.view.alpha = 1
                }
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    toNavVC.view.layer.position = CGPoint(x: bigFrame.midX, y: bigFrame.midY)
                    toNavVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            } completion: { (finished) in
                if finished {
                    UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeLinear]) {
                        toVc.gcdSaveButton.transform = .identity
                        toVc.operationSaveButton.transform = .identity
                        toVc.nameTextView.transform = .identity
                        toVc.descriptionTextView.transform = .identity
                    } completion: { (finish) in
                        transitionContext.completeTransition(finish)
                    }
                } else {
                    transitionContext.completeTransition(false)
                }
            }
        } else {
            guard let toVC = toNavVC.viewControllers.first as? ChannelsListViewController,
                  let image = toVC.profileBarButton.customView
            else {
                transitionContext.completeTransition(true)
                return
            }
            
            let miniImageFrame = image.convert(image.bounds, to: window)
            let bigFrame = toNavVC.view.convert(toNavVC.view.bounds, to: window)
            
            let scale = (miniImageFrame.maxX - miniImageFrame.minX) / (bigFrame.maxX - bigFrame.minX)

            UIView.animateKeyframes(withDuration: duration,
                                    delay: 0,
                                    options: [.calculationModeLinear]) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    fromNavVC.view.layer.position = CGPoint(x: miniImageFrame.midX, y: miniImageFrame.midY)
                    fromNavVC.view.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
                    fromNavVC.view.alpha = 0
                }
            } completion: { (finished) in
                fromNavVC.view.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        }
    }
}
