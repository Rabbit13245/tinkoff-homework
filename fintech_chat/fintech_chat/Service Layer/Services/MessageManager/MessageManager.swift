import Foundation
import CoreData

class MessageManager: IMessageManager {
    
    // MARK: - Dependencies
    
    private var firebaseClient: IFirebaseCleint
    
    // MARK: - Initializers
    
    init(firebaseClient: IFirebaseCleint) {
        self.firebaseClient = firebaseClient
    }
    
    /// Подписаться на сообщения в канале
    public func subscribeOnChannelMessages(channelId: String) {
        
//        FirebaseManager.shared.getAllMessages(from: self.channel.identifier) {[weak self] (result) in
//            guard let safeSelf = self else { return }
//            switch result {
//            case .success(let documentChanges):
//                var modified = [Message]()
//                var added = [Message]()
//                var removed = [Message]()
//
//                for change in documentChanges {
//                    guard let channel = Message(change.document) else { continue }
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
//                CoreDataStack.shared.addNewMessages(added, for: safeSelf.channel.objectID)
//            case .failure:
//                safeSelf.presentMessage("Error getting messages from firebase")
//            }
//        }
    }
    
    /// Отправить сообщение в канал
    public func sendMessage(_ text: String, to channelId: String, completion: @escaping (Error?) -> Void) {
        
    }
    
//    func addNewMessages(_ messages: [Message], for channelId: NSManagedObjectID) {
//        performSave { (context) in
//            guard let channelToAdd = context.object(with: channelId) as? ChannelDb else { return }
//            let messagesDbToAdd = messages.map { MessageDb(message: $0, in: context) }
//            let setMessages = NSSet(array: messagesDbToAdd)
//            channelToAdd.addToMessages(setMessages)
//        }
//    }
}
