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
                
            case .failure(let error):
                completion(error)
            }
        }
    }
}