import Foundation
import CoreData

@objc(MessageDb)
public class MessageDb: NSManagedObject {
    convenience init(message: Message, in context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.content = message.content
        self.created = message.created
        self.senderId = message.senderId
        self.senderName = message.senderName
    }
}

extension MessageDb {
    var statistic: String {
        let description = "SenderName: \(self.senderName). Time: \(self.created). Message: \(self.content).\n"
        
        return description
    }
}
