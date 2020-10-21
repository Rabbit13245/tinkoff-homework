import Foundation
import Firebase

struct Channel {
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
}
