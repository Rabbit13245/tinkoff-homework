import UIKit
import Firebase

public enum DatabaseError: Error {
    case failedToRead
    case failedToSend
    case failedToCreateChannel
    case failedToRemoveChannel
    public var description: String {
        switch self {
        case .failedToRead:
            return "Error reading data"
            
        case .failedToSend:
            return "Error sending data"
            
        case .failedToCreateChannel:
            return "Error creating channel"
        case .failedToRemoveChannel:
            return "Error removing channel"
        }
    }
}

class FirebaseCleint: IFirebaseCleint {
    // MARK: - Private properties
    
    /// Ссылка на коллекцию каналов
    private let channels = Firestore.firestore().collection("channels")
    
    /// Уникальный id  юзера в рамках приложения
    let myId = UIDevice.current.identifierForVendor?.uuidString
    
    /// Получить все каналы
    public func getAllChannels(completion: @escaping ((Result<[Channel], Error>) -> Void)) {
        channels.getDocuments { (snapshot, error) in
            if let error = error {
                Logger.app.logMessage("\(#function):: Error fetching data: \(error.localizedDescription)",
                    logLevel: .error)
                completion(.failure(DatabaseError.failedToRead))
            }
            if let snapshot = snapshot {
                completion(.success(self.parseChannels(snapshot.documents)))
            }
        }
    }
    
    /// Подписаться на обновления каналов
    public func subscribeChannelsUpdates(completion: @escaping (Result<FirebaseData<Channel>, Error>) -> Void) {
        channels.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Logger.app.logMessage("\(#function):: Error reading data: \(error.localizedDescription)",
                                      logLevel: .error)
                completion(.failure(DatabaseError.failedToRead))
            } else {
                if let snapshot = querySnapshot {
                    let data = FirebaseData<Channel>(documentChanges: snapshot.documentChanges)
                    completion(.success(data))
                } else {
                    Logger.app.logMessage("\(#function):: Snapshot is nil", logLevel: .error)
                    completion(.failure(DatabaseError.failedToRead))
                }
            }
        }
    }
    
    /// Создать канал
    public func createChannel(_ channelDocument: [String: Any], completion: @escaping ((Error?) -> Void)) {
        channels.addDocument(data: channelDocument) { (error) in
            if let safeError = error {
                Logger.app.logMessage("Create channel error: \(safeError.localizedDescription)", logLevel: .error)
                completion(DatabaseError.failedToCreateChannel)
            }
            completion(nil)
        }
    }
    
    /// Удалить канал
    public func removeChannel(with channelId: String, completion: @escaping ((Error?) -> Void)) {
        channels.document(channelId).delete { (error) in
            if let safeError = error {
                Logger.app.logMessage("Create channel error: \(safeError.localizedDescription)", logLevel: .error)
                completion(DatabaseError.failedToRemoveChannel)
            }
            completion(nil)
        }
    }
    
    /// Подписаться на обновления сообщений в канале
    public func subscribeMessagesUpdates(with channelId: String, completion: @escaping ((Result<FirebaseData<Message>, Error>) -> Void)) {
        channels.document(channelId).collection("messages").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Logger.app.logMessage("\(#function):: Error reading data: \(error.localizedDescription)",
                    logLevel: .error)
                completion(.failure(DatabaseError.failedToRead))
            } else {
                if let snapshot = querySnapshot {
                    let data = FirebaseData<Message>(documentChanges: snapshot.documentChanges)
                    completion(.success(data))
                } else {
                    Logger.app.logMessage("\(#function):: Snapshot is nil", logLevel: .error)
                    completion(.failure(DatabaseError.failedToRead))
                }
            }
        }
    }

    /// Отправить сообщение
    public func sendMessage(_ text: String, from userId: String, to channelId: String, completion: @escaping (Error?) -> Void) {
        
        let messageData: [String: Any] = [
            "content": text,
            "created": Timestamp(),
            "senderId": userId,
            "senderName": "Dmitry Zaytcev"
        ]
        
        channels.document(channelId).collection("messages").addDocument(data: messageData) { (error) in
            if let safeError = error {
                Logger.app.logMessage("Cant send message: \(safeError.localizedDescription)", logLevel: .error)
                completion(DatabaseError.failedToSend)
                return
            }
            completion(nil)
        }
    }
}

extension FirebaseCleint {
    private func parseChannels(_ documents: [QueryDocumentSnapshot]) -> [Channel] {
        let channels = documents.compactMap {Channel($0)}
        let sortedChannels = channels.sorted {
            $0.lastActivity ?? .distantPast > $1.lastActivity ?? .distantPast
        }
        
        return sortedChannels
    }
    
    private func parseMessages(_ documents: [QueryDocumentSnapshot]) -> [Message] {
        let messages = documents.compactMap {Message($0)}
        return messages.sorted {
            $0.created < $1.created
        }
    }
}
