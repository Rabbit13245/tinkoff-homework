import UIKit

class Logger {
    static var app: Logger = {
        return Logger()
    }()

    private init() {}

    var globalLogLevel = Bundle.main.object(forInfoDictionaryKey: "LogLevel") as? String

    func convertAppStateToString(_ state: UIApplication.State) -> String {
        switch state {
        case .active:
            return "Active"
        case .background:
            return "Background"
        case .inactive:
            return "Inactive"
        default:
            return "Unknown"
        }
    }

    func logMessage(_ message: String, logLevel: LogLevels = .debug) {
        switch globalLogLevel?.lowercased() {
        case "debug":
            print("[Debug]: \(message)")
        case "info":
            if logLevel.rawValue > 0 {
                print("[Info]: \(message)")
            }
        case "warning":
            if logLevel.rawValue > 1 {
                print("[Warning]: \(message)")
            }
        case "error":
            if logLevel.rawValue > 2 {
                print("[Error]: \(message)")
            }
        default:
            return
        }
    }
}
