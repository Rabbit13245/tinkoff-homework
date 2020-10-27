import Foundation
import CoreData

extension ChannelDb {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelDb> {
        return NSFetchRequest<ChannelDb>(entityName: "ChannelDb")
    }

    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension ChannelDb {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageDb)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageDb)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
