import Foundation
import CoreData

class ChannelManager: IChannelManager {
    
    // MARK: - Private properties
    /// Флаг первого запроса к firebase для актуализации данных
    private var firstRequest = true
    
    // MARK: - Dependencies
    
    private var firebaseClient: IFirebaseClient
    private var coreDataClient: ICoreDataClient
    
    // MARK: - Initializers
    
    init(firebaseClient: IFirebaseClient, coreDataClient: ICoreDataClient) {
        self.firebaseClient = firebaseClient
        self.coreDataClient = coreDataClient
    }
    
    /// Подписаться на обновления каналов из firebase
    func subscribeChannels(completion: @escaping ((Error?) -> Void)) {
        if firstRequest {
            firebaseClient.getAllChannels { [weak self] (result) in
                switch result {
                case .success(let channels):
                    let ids = channels.map { $0.identifier }
                    self?.coreDataClient.removeDeletedChannels(ids: ids)
                case .failure:
                    Logger.app.logMessage("Error first time getting channels from firebase", logLevel: .error)
                }
                self?.firstRequest = false
                self?.subscribeChannelsUpdates(completion: completion)
            }
        } else {
            subscribeChannelsUpdates(completion: completion)
        }
    }
    
    /// Создать канал
    public func createChannel(with name: String, completion: @escaping ((Error?) -> Void)) {
        
        
        let channelDocument: [String: Any] = [
            "name": name
        ]
        
        firebaseClient.createChannel(channelDocument, completion: completion)
    }
    
    /// Удалить канал
    public func removeChannel(_ channelId: String, completion: @escaping ((Error?) -> Void)) {
        firebaseClient.removeChannel(with: channelId, completion: completion)
    }
    
    // MARK: - Private
    
    private func subscribeChannelsUpdates(completion: @escaping ((Error?) -> Void)) {
        firebaseClient.subscribeChannelsUpdates { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.coreDataClient.addNewChannels(data.added)
                self?.coreDataClient.removeChannels(data.removed)
                self?.coreDataClient.modifyChannels(data.modified)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
}
