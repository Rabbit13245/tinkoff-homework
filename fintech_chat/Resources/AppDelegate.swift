import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: AppWindow?

    var previousState: UIApplication.State = .inactive
    
    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        previousState = application.applicationState
       
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        setupApp(application)

        self.window = AppWindow(frame: UIScreen.main.bounds)
        let navVC = rootAssembly.presentationAssembly.mainNavigationController()
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        
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

extension AppDelegate {
    private func setupApp(_ application: UIApplication) {
        FirebaseApp.configure()
        CoreDataStack.shared.enableObservers()
        
//        CoreDataStack.shared.didUpdateDataBase = { stack in
//            stack.printStatistic()
//        }
    }
}
