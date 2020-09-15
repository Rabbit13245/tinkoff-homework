//
//  AppDelegate.swift
//  fintech_chat
//
//  Created by Admin on 9/14/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let needLog = Bundle.main.object(forInfoDictionaryKey: "NeedLog") as! String
    var previousState: UIApplication.State = .inactive
    
//    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        if (needLog == "YES"){
//            print(#function)
//            print(Helper.app.convertAppStateToString(application.applicationState))
//            previousState = application.applicationState
//        }
//        return true
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if (needLog == "YES"){
            print("application moved from 'Not Runnig' to '\(Helper.app.convertAppStateToString(application.applicationState))': \(#function)")
            previousState = application.applicationState
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application moved from 'Inactive' to 'Active': \(#function)")
//            print("application moved from '\(Helper.app.convertAppStateToString(previousState))' to '\(Helper.app.convertAppStateToString(application.applicationState))': \(#function)")
            previousState = application.applicationState
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application will move from 'Active' to 'Inactive': \(#function)")
//            print("application moved from '\(Helper.app.convertAppStateToString(previousState))' to '\(Helper.app.convertAppStateToString(application.applicationState))': \(#function)")
            previousState = application.applicationState
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application moved from 'Inactive' to 'Background': \(#function)")
//            print("application moved from '\(Helper.app.convertAppStateToString(previousState))' to '\(Helper.app.convertAppStateToString(application.applicationState))': \(#function)")
            previousState = application.applicationState
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application will move from 'Background' to 'Inactive': \(#function)")
//            print("application moved from '\(Helper.app.convertAppStateToString(previousState))' to '\(Helper.app.convertAppStateToString(application.applicationState))': \(#function)")
            previousState = application.applicationState
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application moved from 'Background' to 'Not runnig' or 'Suspended': \(#function)")
        }
    }
}
