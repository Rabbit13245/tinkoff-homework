import Foundation

struct MessageCellModel {
    let direction: MessageDirection
    let message: Message

    init(message: Message) {
        self.message = message
        if self.message.senderId == DbManager.shared.myId {
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
