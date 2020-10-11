//
//  ConfigurableView.swift
//  fintech_chat
//
//  Created by Admin on 9/29/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol ConfigurableView{
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
