import UIKit

enum vcState{
    case disappearing
    case appearing
    case appeared
    case disappeared
}

class BaseViewController: UIViewController {

    var currentState = vcState.disappeared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (currentState == .disappearing){
            Logger.app.logMessage("VC moved from 'Disappearing' to 'Appearing': \(#function)", logLevel: .Debug)
        }
        else{
            Logger.app.logMessage("VC moved from 'Disappeared' to 'Appearing': \(#function)", logLevel: .Debug)
        }
        currentState = .appearing
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        Logger.app.logMessage("VC moved from 'Appearing' to 'Appeared': \(#function)", logLevel: .Debug)
        currentState = .appeared
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        if (currentState == .appearing){
            Logger.app.logMessage("VC moved from 'Appearing' to 'Disappearing': \(#function)", logLevel: .Debug)
        }
        else{
            Logger.app.logMessage("VC moved from 'Appeared' to 'Disappearing': \(#function)", logLevel: .Debug)
        }
        currentState = .disappearing
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.app.logMessage("VC moved from 'Disappearing' to 'Disappeared': \(#function)", logLevel: .Debug)
        currentState = .disappeared
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Logger.app.logMessage(#function, logLevel: .Debug)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.app.logMessage(#function, logLevel: .Debug)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
