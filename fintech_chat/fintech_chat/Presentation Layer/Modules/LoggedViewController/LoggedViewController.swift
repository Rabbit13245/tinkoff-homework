import UIKit

enum VCState {
    case disappearing
    case appearing
    case appeared
    case disappeared
}

class LoggedViewController: UIViewController {

    var currentState = VCState.disappeared

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
}
