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
        self.lastMessage = rawData["lastMessage"] as? String
        self.lastActivity = (rawData["lastActivity"] as? Timestamp)?.dateValue()
    }
}
