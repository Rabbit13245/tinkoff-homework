import Foundation
import CoreData

class CoreDataClient: ICoreDataClient {
    
    // MARK: - Dependencies
    
    private let coreDataStack = CoreDataStack.shared
    
    init() {
        coreDataStack.enableObservers()
    }
    
    /// Удалить каналы, что были удалены в фаербейс
    public func removeDeletedChannels(ids: [String]) {
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        request.predicate = NSPredicate(format: "NOT identifier IN %@", ids)
        
        coreDataStack.performSave { (context) in
            guard let channelsToRemove = try? context.fetch(request),
                  channelsToRemove.count > 0 else { return }
            
            channelsToRemove.forEach {
                context.delete($0)
            }
        }
    }
    
    /// Добавить новые каналы
    func addNewChannels(_ channels: [Channel]) {
        coreDataStack.performSave { (context) in
            channels.forEach { (singleChannel) in
                _ = ChannelDb(channel: singleChannel, in: context)
            }
        }
    }
    
    /// Обновить существующие каналы
    func modifyChannels(_ channels: [Channel]) {
        coreDataStack.performSave { (context) in
            channels.forEach { (singleChannel) in
                guard let existChannel = self.getChannel(with: singleChannel.identifier, in: context) else { return }
                existChannel.setValue(singleChannel.lastActivity, forKey: "lastActivity")
                existChannel.setValue(singleChannel.lastMessage, forKey: "lastMessage")
                existChannel.setValue(singleChannel.name, forKey: "name")
            }
        }
    }
    
    /// Удалить каналы
    func removeChannels(_ channels: [Channel]) {
        coreDataStack.performSave { (context) in
            channels.forEach { (singleChannel) in
                guard let channelForRemove = self.getChannel(with: singleChannel.identifier, in: context) else { return }
                context.delete(channelForRemove)
            }
        }
    }
    
    /// Добавить новые сообщения
    func addNewMessages(_ messages: [Message], for channelId: String) {
        coreDataStack.performSave { (context) in
            guard let channelToAdd = self.getChannel(with: channelId, in: context) else { return }
            let messagesDbToAdd = messages.map { MessageDb(message: $0, in: context) }
            let setMessages = NSSet(array: messagesDbToAdd)
            channelToAdd.addToMessages(setMessages)
        }
    }
    
    // MARK: - Private functions
    
    /// Получить канал по id
    private func getChannel(with id: String, in context: NSManagedObjectContext? = nil) -> ChannelDb? {
        do {
            let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
            
            let predicate = NSPredicate(format: "identifier == %@", id)
            request.predicate = predicate
            
            let contextForRequest = context ?? coreDataStack.mainContext
            let channels = try contextForRequest.fetch(request)
            
            return channels.first
        } catch {
            Logger.app.logMessage("getChannel Error \(error.localizedDescription)", logLevel: .error)
            return nil
        }
    }
}
