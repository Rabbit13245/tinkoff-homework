import UIKit

class AppWindow: UIWindow {
    
    private lazy var logoCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "tink_g")?.cgImage
        cell.scale = 0.08
        cell.scaleRange = 0.2
        cell.emissionLongitude = .pi
        cell.emissionRange = 2 * .pi
        cell.lifetime = 0.5
        cell.birthRate = 10
        cell.velocity = 100
        cell.velocityRange = 300
        cell.yAcceleration = 50
        cell.xAcceleration = 50
        cell.spin = -0.5
        cell.spinRange = 1.0
        return cell
    }()
    
    private func logoRemove(_ layer: CAEmitterLayer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            layer.removeFromSuperlayer()
        }
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
    
    override func sendEvent(_ event: UIEvent) {
        event.touches(for: self)?.forEach({ (singleTouch) in
            
            let viewForAnimate = topMostController()?.view ?? singleTouch.view?.superview ?? singleTouch.view
            let point = singleTouch.location(in: viewForAnimate)
            
            let layer = CAEmitterLayer()
            layer.emitterSize = CGSize(width: 60, height: 60)
            layer.emitterShape = .point
            layer.beginTime = CACurrentMediaTime()
            layer.timeOffset = CFTimeInterval(arc4random_uniform(10) + 1)
            layer.emitterCells = [logoCell]
            layer.renderMode = .additive
            layer.emitterPosition = point
            
            viewForAnimate?.layer.addSublayer(layer)
            
            self.logoRemove(layer)
        })
        super.sendEvent(event)
    }
}
