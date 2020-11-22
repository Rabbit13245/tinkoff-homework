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
        let description = "📱 Id: \(self.identifier), name: \(self.name), last message: \"\(String(describing: lastMessage))\" at \(String(describing: lastActivity))\n"
        
        let messages = self.messages?.allObjects
            .compactMap { $0 as? MessageDb }
            .map { "✉️ \($0.statistic)" }
            .joined(separator: "\n") ?? ""
        
        return description + messages
    }
}
