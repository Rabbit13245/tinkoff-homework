import Foundation
import Firebase

struct Channel: IFirebaseInit {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?

    init?(_ data: QueryDocumentSnapshot) {
        let rawData = data.data()
        guard let channelName = rawData["name"] as? String else { return nil}
        self.identifier = data.documentID

        self.name = channelName
        
        let receiedLastMessage = rawData["lastMessage"] as? String
        let receivedLastActivity = rawData["lastActivity"] as? Timestamp
        
        if receiedLastMessage == nil && receivedLastActivity != nil ||
            receiedLastMessage != nil && receivedLastActivity == nil {
            return nil
        }
        
        self.lastMessage = receiedLastMessage
        self.lastActivity = receivedLastActivity?.dateValue()
    }
    
    init(_ data: ChannelDb) {
        self.identifier = data.identifier
        self.name = data.name
        self.lastMessage = data.lastMessage
        self.lastActivity = data.lastActivity
    }
    
    /// initializer по всем параметрам
    init(identifier: String,
         name: String,
         lastMessage: String?,
         lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
}
