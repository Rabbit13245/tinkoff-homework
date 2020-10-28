import Foundation
import CoreData

@objc(ChannelDb)
public class ChannelDb: NSManagedObject {
    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
}

extension ChannelDb {
    var statistic: String {
        let description = "Id: \(self.identifier), name: \(self.name).\n"
        
        if let lastMessage = self.lastMessage,
            let lastActivity = self.lastActivity {
            let messageDescription = "Last message: \"\(lastMessage)\" at \(lastActivity)"
            
            return description + messageDescription
        }
        
        return description
    }
}
