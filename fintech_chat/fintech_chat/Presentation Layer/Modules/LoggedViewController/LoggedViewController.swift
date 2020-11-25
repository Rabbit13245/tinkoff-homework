import UIKit

enum VCState {
    case disappearing
    case appearing
    case appeared
    case disappeared
}

class LoggedViewController: UIViewController {

    // MARK: - UI
    
    lazy var logoCell: CAEmitterCell = {
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
        layer.emitterSize = view.bounds.size
        layer.emitterShape = .point
        layer.beginTime = CACurrentMediaTime()
        layer.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
        layer.emitterCells = [logoCell]
        
        return layer
    }()
    
    // MARK: - Private properties
    
    private var currentState = VCState.disappeared

    // MARK: - Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if currentState == .disappearing {
            Logger.app.logMessage("VC moved from 'Disappearing' to 'Appearing': \(#function)", logLevel: .debug)
        } else {
            Logger.app.logMessage("VC moved from 'Disappeared' to 'Appearing': \(#function)", logLevel: .debug)
        }
        currentState = .appearing
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Logger.app.logMessage("VC moved from 'Appearing' to 'Appeared': \(#function)", logLevel: .debug)
        currentState = .appeared
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if currentState == .appearing {
            Logger.app.logMessage("VC moved from 'Appearing' to 'Disappearing': \(#function)", logLevel: .debug)
        } else {
            Logger.app.logMessage("VC moved from 'Appeared' to 'Disappearing': \(#function)", logLevel: .debug)
        }
        currentState = .disappearing
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        Logger.app.logMessage("VC moved from 'Disappearing' to 'Disappeared': \(#function)", logLevel: .debug)
        currentState = .disappeared
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        Logger.app.logMessage(#function, logLevel: .debug)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        Logger.app.logMessage(#function, logLevel: .debug)
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.addTarget(self, action: #selector(tapAction(_:)))
        
        return tap
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer()
        longPress.addTarget(self, action: #selector(longPressAction))
        longPress.cancelsTouchesInView = false
        
        return longPress
    }()
    
    private lazy var swipeGesture: UIPanGestureRecognizer = {
        let swipe = UIPanGestureRecognizer()
        swipe.addTarget(self, action: #selector(swipeAction))
        swipe.cancelsTouchesInView = false
        
        return swipe
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController != nil {
            if let gesturesCount = navigationController?.view.gestureRecognizers?.count {
                if gesturesCount < 2 {
                    navigationController?.view.addGestureRecognizer(tapGesture)
                    navigationController?.view.addGestureRecognizer(longPressGesture)
                    navigationController?.view.addGestureRecognizer(swipeGesture)
                }
            } else {
                navigationController?.view.addGestureRecognizer(tapGesture)
                navigationController?.view.addGestureRecognizer(longPressGesture)
                navigationController?.view.addGestureRecognizer(swipeGesture)
            }
        } else {
            view.addGestureRecognizer(tapGesture)
            view.addGestureRecognizer(longPressGesture)
            view.addGestureRecognizer(swipeGesture)
        }
    }
    
    // MARK: - Private methods
    
    @objc private func tapAction(_ gestureRecognizer: UITapGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            logoShow(from: gestureRecognizer.location(in: navigationController?.view ?? view))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.logoRemove()
            }
        default:
            print("Default")
        }
    }
    
    @objc private func longPressAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            logoShow(from: gestureRecognizer.location(in: navigationController?.view ?? view))
        case .changed:
            logoLayer.emitterPosition = gestureRecognizer.location(in: navigationController?.view ?? view)
        case .cancelled:
            logoRemove()
        case .ended:
            logoRemove()
        default:
            print("Default")
        }
    }
    
    @objc private func swipeAction(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            logoShow(from: gestureRecognizer.location(in: view))
        case .changed:
            logoLayer.emitterPosition = gestureRecognizer.location(in: view)
        case .cancelled:
            logoRemove()
        case .ended:
            logoRemove()
        default:
            print("Default")
        }
    }
    
    private func logoShow(from point: CGPoint) {
        logoLayer.emitterPosition = point
        navigationController?.view.layer.addSublayer(logoLayer)
        //view.layer.addSublayer(logoLayer)
    }
    
    private func logoRemove() {
        logoLayer.removeAllAnimations()
        logoLayer.removeFromSuperlayer()
    }
    
    // MARK: - Public methods
    
    let del = GestureDelegate()
    
    /// Назначить делегата жестам
    func addGestureDelegates(delegate: UIGestureRecognizerDelegate) {
        tapGesture.delegate = delegate
        longPressGesture.delegate = delegate
        //swipeGesture.delegate = del
    }
}
