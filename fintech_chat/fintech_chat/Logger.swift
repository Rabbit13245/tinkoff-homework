//
//  Helpers.swift
//  fintech_chat
//
//  Created by Admin on 9/15/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class Logger{
    static var app: Logger = {
        return Logger()
    }()
    
    private init() {}
    
    var needLog = Bundle.main.object(forInfoDictionaryKey: "NeedLog") as? String
    
    func convertAppStateToString(_ state: UIApplication.State) -> String{
        switch(state){
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
    
    func logMessage(_ message: String){
        if (needLog == "YES"){
            print(message)
        }
    }
}
