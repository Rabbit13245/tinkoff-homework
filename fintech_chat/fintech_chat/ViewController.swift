//
//  ViewController.swift
//  fintech_chat
//
//  Created by Admin on 9/14/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

enum vcState{
    case disappearing
    case appearing
    case appeared
    case disappeared
}

class ViewController: UIViewController {

    var currentState = vcState.disappeared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (currentState == .disappearing){
            Logger.app.logMessage("VC moved from 'Disappearing' to 'Appearing': \(#function)")
        }
        else{
            Logger.app.logMessage("VC moved from 'Disappeared' to 'Appearing': \(#function)")
        }
        currentState = .appearing
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.app.logMessage("VC moved from 'Appearing' to 'Appeared': \(#function)")
        currentState = .appeared
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        if (currentState == .appearing){
            Logger.app.logMessage("VC moved from 'Appearing' to 'Disappearing': \(#function)")
        }
        else{
            Logger.app.logMessage("VC moved from 'Appeared' to 'Disappearing': \(#function)")
        }
        currentState = .disappearing
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.app.logMessage("VC moved from 'Disappearing' to 'Disappeared': \(#function)")
        currentState = .disappeared
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Logger.app.logMessage(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.app.logMessage(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}
