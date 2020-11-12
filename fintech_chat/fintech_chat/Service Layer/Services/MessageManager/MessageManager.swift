import Foundation
import UIKit

class MessageManager: IMessageManager {
    
    // MARK: - Private properties
    let myId = UIDevice.current.identifierForVendor?.uuidString
    
    // MARK: - Dependencies
    
    private var firebaseClient: IFirebaseCleint
    private var coreDataClient: ICoreDataClient
    
    // MARK: - Initializers
    
    init(firebaseClient: IFirebaseCleint, coreDataClient: ICoreDataClient) {
        self.firebaseClient = firebaseClient
        self.coreDataClient = coreDataClient
    }
    
    /// Подписаться на сообщения в канале
    public func subscribeOnChannelMessagesUpdates(channelId: String) {
        firebaseClient.subscribeMessagesUpdates(with: channelId) { [weak self] (result) in
            switch result {
            case .success(let documentChanges):
                var modified = [Message]()
                var added = [Message]()
                var removed = [Message]()
                
                for change in documentChanges {
                    guard let channel = Message(change.document) else { continue }
                    switch change.type {
                    case .added:
                        added.append(channel)
                    case .removed:
                        removed.append(channel)
                    case .modified:
                        modified.append(channel)
                    }
                }
                
                self?.coreDataClient.addNewMessages(added, for: channelId)
            case .failure:
                print("FFFFAAAIILLUURREE")
            }
        }
    }
    
    /// Отправить сообщение в канал
    public func sendMessage(_ text: String, to channelId: String, completion: @escaping (Error?) -> Void) {
        
        guard let safeId = myId else {
            Logger.app.logMessage("Cant get uuid device. ", logLevel: .error)
            completion(DatabaseError.failedToSend)
            return
        }
        
        firebaseClient.sendMessage(text, from: safeId, to: channelId, completion: completion)
    }
}
