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
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        if (needLog == "YES"){
//            print(#function)
//        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if (needLog == "YES"){
            print("application moved from 'Not Runnig' to 'Inactive': \(#function)")
            //print(#function)
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application moved from 'Inactive' to 'Active': \(#function)")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application moved from 'Active' to 'Inactive': \(#function)")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application moved from 'Inactive' to 'Background': \(#function)")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application moved from 'Background' to 'Inactive': \(#function)")
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if (needLog == "YES"){
            print("application moved from 'Background' to 'Not runnig' or 'Suspended': \(#function)")
        }
    }
}

