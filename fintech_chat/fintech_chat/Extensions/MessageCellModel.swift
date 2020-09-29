//
//  MessageCellModel.swift
//  fintech_chat
//
//  Created by Макбук on 27.09.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct MessageCellModel{
    let text: String
    let direction: MessageDirection
}

enum MessageDirection{
    case input
    case output
}
