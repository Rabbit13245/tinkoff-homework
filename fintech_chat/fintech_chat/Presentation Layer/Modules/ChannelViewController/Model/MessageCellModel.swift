import Foundation
import UIKit

struct MessageCellModel {
    let direction: MessageDirection
    let message: Message

    init(message: Message) {
        self.message = message
        
        if self.message.senderId == UIDevice.current.identifierForVendor?.uuidString {
            self.direction = .output
        } else {
            self.direction = .input
        }
    }
}

enum MessageDirection {
    case input
    case output
}
