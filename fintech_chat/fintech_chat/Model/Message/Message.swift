import Foundation
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String

    init?(_ data: QueryDocumentSnapshot) {
        let rawData = data.data()
        guard let content = rawData["content"] as? String,
            let created = (rawData["created"] as? Timestamp)?.dateValue(),
        let senderId = rawData["senderId"] as? String,
        let senderName = rawData["senderName"] as? String
            else {return nil}

        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
}
