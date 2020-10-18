import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var previousState: UIApplication.State = .inactive
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Logger.app.logMessage("application moved from 'Not Runnig' to '\(Logger.app.convertAppStateToString(application.applicationState))': \(#function)")
        previousState = application.applicationState
        
        FirebaseApp.configure()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        ThemeManager.shared.apply(for: application)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.app.logMessage("application moved from 'Inactive' to 'Active': \(#function)")
        previousState = application.applicationState
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.app.logMessage("application will move from 'Active' to 'Inactive': \(#function)")
        previousState = application.applicationState
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.app.logMessage("application moved from 'Inactive' to 'Background': \(#function)")
        previousState = application.applicationState
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.app.logMessage("application will move from 'Background' to 'Inactive': \(#function)")
        previousState = application.applicationState
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.app.logMessage("application moved from 'Background' to 'Not runnig' or 'Suspended': \(#function)")
    }
}
