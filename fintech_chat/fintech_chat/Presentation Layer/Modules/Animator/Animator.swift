import UIKit

class Animator: IAnimator {
    
    // MARK: - Shake animation
    
    private let animateTime: CFTimeInterval = 0.3
    private let rotationAngle: Double = Double.pi / 180 * 18
    private let changePosition: CGFloat = 5
    private let rotationKeyPath = "transform.rotation.z"
    private let positionXKeyPath = "position.x"
    private let positionYKeyPath = "position.y"
    private let animateKey = "animateKey"
    private var initialPosition: CGPoint?
    
    public func startShake(_ view: UIView?) {
        initialPosition = view?.center
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: rotationKeyPath)
        rotateAnimation.values = [0, rotationAngle, 0, -rotationAngle, 0]
        rotateAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        rotateAnimation.isAdditive = true

        let upDownAnimation = CAKeyframeAnimation(keyPath: positionYKeyPath)
        upDownAnimation.values = [0, -changePosition, 0, changePosition, 0]
        upDownAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        upDownAnimation.isAdditive = true

        let lefRightAnimation = CAKeyframeAnimation(keyPath: positionXKeyPath)
        lefRightAnimation.values = [0, changePosition, 0, -changePosition, 0]
        lefRightAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        lefRightAnimation.isAdditive = true

        let group = CAAnimationGroup()
        group.duration = animateTime
        group.animations = [rotateAnimation, upDownAnimation, lefRightAnimation]
        group.repeatCount = .infinity
        group.isRemovedOnCompletion = false

        view?.layer.add(group, forKey: animateKey)
    }
    
    public func stopShake(_ view: UIView?) {
        let rot = CABasicAnimation(keyPath: rotationKeyPath)
        rot.fromValue = view?.layer.presentation()?.value(forKeyPath: rotationKeyPath)
        rot.toValue = 0
        rot.isAdditive = true
        
        let up = CABasicAnimation(keyPath: positionYKeyPath)
        up.fromValue = view?.layer.presentation()?.value(forKeyPath: positionYKeyPath)
        up.toValue = initialPosition?.y

        let left = CABasicAnimation(keyPath: positionXKeyPath)
        left.fromValue = view?.layer.presentation()?.value(forKeyPath: positionXKeyPath)
        left.toValue = initialPosition?.x

        let group = CAAnimationGroup()
        group.duration = animateTime
        group.animations = [rot, up, left]

        view?.layer.add(group, forKey: animateKey)

        DispatchQueue.main.asyncAfter(deadline: .now() + animateTime) { [weak self] in
            guard let safeSelf = self else { return }
            view?.layer.removeAnimation(forKey: safeSelf.animateKey)
        }
    }
}
