import Foundation
import Firebase

struct Message {
    let id: String
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

        self.id = data.documentID
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init(_ data: MessageDb) {
        self.id = data.id
        self.content = data.content
        self.created = data.created
        self.senderId = data.senderId
        self.senderName = data.senderName
    }
    
    /// Initializer по всем параметрам
    init(id: String,
         content: String,
         created: Date,
         senderId: String,
         senderName: String) {
        self.id = id
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
}
