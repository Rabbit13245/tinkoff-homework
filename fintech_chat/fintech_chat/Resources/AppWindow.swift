import UIKit

class AppWindow: UIWindow {
    
    private lazy var logoCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "tink_g")?.cgImage
        cell.scale = 0.08
        cell.scaleRange = 0.2
        cell.emissionRange = 2 * .pi
        cell.lifetime = 0.5
        cell.birthRate = 10
        cell.velocity = 50
        cell.velocityRange = 300
        cell.yAcceleration = 30
        cell.xAcceleration = 30
        cell.spin = -0.5
        cell.spinRange = 1.0
        return cell
    }()
    
    private lazy var logoLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        // layer.emitterPosition = point
        layer.emitterSize = bounds.size
        layer.emitterShape = .point
        layer.beginTime = CACurrentMediaTime()
        layer.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
        layer.emitterCells = [logoCell]
        
        return layer
    }()
    
    private func logoShow(from point: CGPoint, to view: UIView?) {
        logoLayer.emitterPosition = point
        view?.layer.addSublayer(logoLayer)
    }
    
    private func logoRemove(_ layer: CAEmitterLayer) {
        layer.removeAllAnimations()
        layer.removeFromSuperlayer()
    }
    
    override func sendEvent(_ event: UIEvent) {
        event.touches(for: self)?.forEach({ (singleTouch) in
            
            let viewForAnimate = topMostController()?.view ?? singleTouch.view?.superview ?? singleTouch.view
            let point = singleTouch.location(in: viewForAnimate)
            
            let layer = CAEmitterLayer()
            layer.emitterSize = CGSize(width: 60, height: 60)
            layer.emitterShape = .point
            layer.beginTime = CACurrentMediaTime()
            layer.timeOffset = CFTimeInterval(arc4random_uniform(3) + 1)
            layer.emitterCells = [logoCell]
            
            layer.emitterPosition = point
            
            viewForAnimate?.layer.addSublayer(layer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.logoRemove(layer)
            }
        })
        super.sendEvent(event)
    }
    
    private func topMostController() -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        var topController = rootViewController

        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }
}
