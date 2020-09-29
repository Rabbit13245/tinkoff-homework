//
//  Helper.swift
//  fintech_chat
//
//  Created by Admin on 9/29/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class Helper{
    static var app: Helper = {
        return Helper()
    }()
    
    private init() {}
    
    func generateDefaultAvatar(name: String, width: CGFloat) -> UIView{
        let resultView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        resultView.layer.cornerRadius = resultView.frame.width / 2
        resultView.backgroundColor = UIColor.AppColors.YellowLogo
        
        let label = UILabel()
        label.text = getInitials(from: name)
        label.textAlignment = .center
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        resultView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: resultView.centerYAnchor)
        ])
        
        

        return resultView
    }
    
    func getInitials(from name: String) -> String{
        guard name != "" else {return ""}
        let names = name.components(separatedBy: " ")
        switch(names.count){
            case 0:
                return ""
            case 1:
                return "\(names[0].prefix(1))".uppercased()
            case 2:
                return "\(names[0].prefix(1))\(names[1].prefix(1))".uppercased()
            default:
                return ""
        }
    }
}
