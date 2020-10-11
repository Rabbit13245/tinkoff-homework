//
//  ConversationCellModel.swift
//  fintech_chat
//
//  Created by Макбук on 27.09.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

struct ConversationCellModel {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
    
    var avatar: UIImage?
}
