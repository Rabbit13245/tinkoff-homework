//
//  ViewController.swift
//  fintech_chat
//
//  Created by Admin on 9/14/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let needLog = Bundle.main.object(forInfoDictionaryKey: "NeedLog") as! String
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (needLog == "YES"){
            print(#function)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (needLog == "YES"){
            print("VC moved from 'Disappeared' to 'Appeared': \(#function)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (needLog == "YES"){
            print(#function)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (needLog == "YES"){
            print("VC moved from 'Appeared' to 'Disappeared': \(#function)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (needLog == "YES"){
            print(#function)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (needLog == "YES"){
            print(#function)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        view.backgroundColor = .red
    }


}

