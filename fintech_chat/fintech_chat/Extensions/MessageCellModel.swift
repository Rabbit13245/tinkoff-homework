import Foundation

struct MessageCellModel{
    let text: String
    let direction: MessageDirection
}

enum MessageDirection{
    case input
    case output
}
