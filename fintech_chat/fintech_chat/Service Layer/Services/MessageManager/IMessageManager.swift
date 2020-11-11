import CoreData

protocol IMessageManager {
    /// Добавить новые сообщения в канал
    func addNewMessages(_ messages: [Message], for channelId: NSManagedObjectID)
}
