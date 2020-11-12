import Foundation

struct MessageCellModel {
    let direction: MessageDirection
    let message: Message

    init(message: Message) {
        self.message = message
        
        self.direction = .output
        
//        if self.message.senderId == FirebaseManager.shared.myId {
//            self.direction = .output
//        } else {
//            self.direction = .input
//        }
    }
}

enum MessageDirection {
    case input
    case output
}
