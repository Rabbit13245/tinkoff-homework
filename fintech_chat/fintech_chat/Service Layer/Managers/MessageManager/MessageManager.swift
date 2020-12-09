import Foundation
import UIKit

class MessageManager: IMessageManager {
    
    // MARK: - Private properties
    let myId = UIDevice.current.identifierForVendor?.uuidString
    
    // MARK: - Dependencies
    
    private var firebaseClient: IFirebaseClient
    private var coreDataClient: ICoreDataClient
    
    // MARK: - Initializers
    
    init(firebaseClient: IFirebaseClient, coreDataClient: ICoreDataClient) {
        self.firebaseClient = firebaseClient
        self.coreDataClient = coreDataClient
    }
    
    /// Подписаться на сообщения в канале
    public func subscribeOnChannelMessagesUpdates(channelId: String, completion: @escaping ((Error?) -> Void)) {
        firebaseClient.subscribeMessagesUpdates(with: channelId) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.coreDataClient.addNewMessages(data.added, for: channelId)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    /// Отправить сообщение в канал
    public func sendMessage(_ text: String, to channelId: String, completion: @escaping ((Error?) -> Void)) {
        
        guard let safeId = myId else {
            Logger.app.logMessage("Cant get uuid device. ", logLevel: .error)
            completion(DatabaseError.failedToSend)
            return
        }
        
        firebaseClient.sendMessage(text, from: safeId, to: channelId, completion: completion)
    }
}
