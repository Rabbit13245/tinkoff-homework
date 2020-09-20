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

    var previousState: UIApplication.State = .inactive
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Logger.app.logMessage("application moved from 'Not Runnig' to '\(Logger.app.convertAppStateToString(application.applicationState))': \(#function)")
        previousState = application.applicationState
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
