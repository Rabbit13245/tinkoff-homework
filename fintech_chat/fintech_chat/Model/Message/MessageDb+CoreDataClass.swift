import Foundation
import CoreData

@objc(MessageDb)
public class MessageDb: NSManagedObject {
    convenience init(message: Message, in context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = message.id
        self.content = message.content
        self.created = message.created
        self.senderId = message.senderId
        self.senderName = message.senderName
    }
}

extension MessageDb {
    var statistic: String {
        let description = "[MessageId: \(self.id), senderName: \(self.senderName), time: \(self.created)]\nMessage text: \(self.content).\n"
        
        return description
    }
}
