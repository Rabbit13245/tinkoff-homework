import Foundation
import CoreData

class ChannelManager: IChannelManager {
    
    // MARK: - Private properties
    /// Флаг первого запроса к firebase для актуализации данных
    private var firstRequest = true
    
    // MARK: - Dependencies
    
    private var firebaseClient: IFirebaseCleint
    private var coreDataClient: ICoreDataClient
    
    // MARK: - Initializers
    
    init(firebaseClient: IFirebaseCleint, coreDataClient: ICoreDataClient) {
        self.firebaseClient = firebaseClient
        self.coreDataClient = coreDataClient
    }
    
    /// Подписаться на обновления каналов из firebase
    func subscribeChannels() {
        if firstRequest {
            firebaseClient.getAllChannels { [weak self] (result) in
                switch result {
                case .success(let channels):
                    let ids = channels.map { $0.identifier }
                    self?.coreDataClient.removeDeletedChannels(ids: ids)
                case .failure:
                    print("FAILURE")
                }
                self?.firstRequest = false
                self?.subscribeChannelsUpdates()
            }
        } else {
            subscribeChannelsUpdates()
        }
    }
    
    /// Получить канал по id
    func getChannel(with id: String) -> ChannelDb? {
        return nil
    }
    
    /// Создать канал (Сделано)
    public func createChannel(with name: String, completion: @escaping ((Error?) -> Void)) {
        let channelDocument: [String: Any] = [
            "name": name
        ]
        
        firebaseClient.createChannel(channelDocument, completion: completion)
    }
    
    /// Удалить канал (Сделано)
    public func removeChannel(_ channelId: String, completion: @escaping ((Error?) -> Void)) {
        firebaseClient.removeChannel(with: channelId, completion: completion)
    }
    
    // MARK: - Private
    
    private func subscribeChannelsUpdates() {
        firebaseClient.subscribeChannelsUpdates { [weak self] (result) in
            switch result {
            case .success(let documentChanges):
                var modified = [Channel]()
                var added = [Channel]()
                var removed = [Channel]()
                
                for change in documentChanges {
                    guard let channel = Channel(change.document) else { continue }
                    switch change.type {
                    case .added:
                        added.append(channel)
                    case .removed:
                        removed.append(channel)
                    case .modified:
                        modified.append(channel)
                    }
                }
                
                self?.coreDataClient.addNewChannels(added)
                self?.coreDataClient.removeChannels(removed)
                self?.coreDataClient.modifyChannels(modified)
                
            case .failure:
                print("Error")
            }
        }
    }
    
//    private func subscribeChannelsFromFirebase() {
//        FirebaseManager.shared.getAllChannels { [weak self] (result) in
//            switch result {
//            case .success(let documentChanges):
//                var modified = [Channel]()
//                var added = [Channel]()
//                var removed = [Channel]()
//
//                for change in documentChanges {
//                    guard let channel = Channel(change.document) else { continue }
//                    switch change.type {
//                    case .added:
//                        added.append(channel)
//                    case .removed:
//                        removed.append(channel)
//                    case .modified:
//                        modified.append(channel)
//                    }
//                }
//
//                CoreDataStack.shared.addNewChannels(added)
//                CoreDataStack.shared.removeChannels(removed)
//                CoreDataStack.shared.modifyChannels(modified)
//
//            case .failure:
//                self?.presentMessage("Error getting channels from firebase")
//            }
//        }
//    }
//
//    /// Получить канал по id
//    func getChannel(with id: String, in context: NSManagedObjectContext? = nil) -> ChannelDb? {
//        do {
//            let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
//
//            let predicate = NSPredicate(format: "identifier == %@", id)
//            request.predicate = predicate
//
//            let contextForRequest = context ?? mainContext
//            let channels = try contextForRequest.fetch(request)
//
//            return channels.first
//        } catch {
//            Logger.app.logMessage("getChannel Error \(error.localizedDescription)", logLevel: .error)
//            return nil
//        }
//    }
//
//    /// Добавить новые каналы
//    func addNewChannels(_ channels: [Channel]) {
//        performSave { (context) in
//            channels.forEach { (singleChannel) in
//                _ = ChannelDb(channel: singleChannel, in: context)
//            }
//        }
//    }
//
//    /// Обновить существующие каналы
//    func modifyChannels(_ channels: [Channel]) {
//        performSave { (context) in
//            channels.forEach { (singleChannel) in
//                guard let existChannel = self.getChannel(with: singleChannel.identifier, in: context) else { return }
//                existChannel.setValue(singleChannel.lastActivity, forKey: "lastActivity")
//                existChannel.setValue(singleChannel.lastMessage, forKey: "lastMessage")
//                existChannel.setValue(singleChannel.name, forKey: "name")
//            }
//        }
//    }
//
//    /// Удалить каналы
//    func removeChannels(_ channels: [Channel]) {
//        performSave { (context) in
//            channels.forEach { (singleChannel) in
//                guard let channelForRemove = self.getChannel(with: singleChannel.identifier, in: context) else { return }
//                context.delete(channelForRemove)
//            }
//        }
//    }
//
//    func removeOldChannels(_ channels: [Channel]) {
//        let ids = channels.map { $0.identifier }
//        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
//        request.predicate = NSPredicate(format: "NOT identifier IN %@", ids)
//
//        performSave { (context) in
//            if let channelsToRemove = try? context.fetch(request),
//               channelsToRemove.count > 0 {
//                channelsToRemove.forEach {
//                    context.delete($0)
//                }
//            }
//        }
//    }
}
