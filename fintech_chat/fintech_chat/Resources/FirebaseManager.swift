import Foundation
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

class FirebaseManager {

    public static let shared: FirebaseManager = {
        let dbManager = FirebaseManager()
        return dbManager
    }()

    private init() {}

    private let channels = Firestore.firestore().collection("channels")

    let myId = UIDevice.current.identifierForVendor?.uuidString
}

// MARK: - Channels
extension FirebaseManager {
    /// Получить все каналы первый раз, для актуализации списка в кор дата
    public func getAllChannelsFirstTime(competion: @escaping ((Result<[Channel], Error>) -> Void)) {
        channels.getDocuments { (snapshot, error) in
            if let error = error {
                Logger.app.logMessage("\(#function):: Error fetching data: \(error.localizedDescription)",
                    logLevel: .error)
                //completion(.failure(DatabaseError.failedToRead))
            }
            if let snapshot = snapshot {
                competion(.success(self.parseChannels(snapshot.documents)))
            }
        }
    }
    
    /// Подписка на обновления данных из firebase
    public func getAllChannels(completion: @escaping (Result<[DocumentChange], Error>) -> Void) {
        channels.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Logger.app.logMessage("\(#function):: Error reading data: \(error.localizedDescription)",
                    logLevel: .error)
                completion(.failure(DatabaseError.failedToRead))
            } else {
                if let snapshot = querySnapshot {
                    let documentChanges = snapshot.documentChanges
                    completion(.success(documentChanges))
                } else {
                    Logger.app.logMessage("\(#function):: Snapshot is nil", logLevel: .error)
                    completion(.failure(DatabaseError.failedToRead))
                }
            }
        }
    }

    public func createChannel(with name: String, completion: @escaping ((Error?) -> Void)) {
        let channelDocument: [String: Any] = [
            "name": name
        ]

        channels.addDocument(data: channelDocument) { (error) in
            if let safeError = error {
                Logger.app.logMessage("Create channel error: \(safeError.localizedDescription)", logLevel: .error)
                completion(DatabaseError.failedToCreateChannel)
            }
            completion(nil)
        }
    }
    
    public func removeChannel(with channelId: String, completion: @escaping ((Error?) -> Void)) {
        channels.document(channelId).delete { (error) in
            if let safeError = error {
                Logger.app.logMessage("Create channel error: \(safeError.localizedDescription)", logLevel: .error)
                completion(DatabaseError.failedToRemoveChannel)
            }
            completion(nil)
        }
    }
}

// MARK: - Messages
extension FirebaseManager {
    public func getAllMessages(from channelId: String, completion: @escaping ((Result<[DocumentChange], Error>) -> Void)) {
        channels.document(channelId).collection("messages").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Logger.app.logMessage("\(#function):: Error reading data: \(error.localizedDescription)",
                    logLevel: .error)
                completion(.failure(DatabaseError.failedToRead))
            } else {
                if let snapshot = querySnapshot {
                    let documentChanges = snapshot.documentChanges
                    completion(.success(documentChanges))
                } else {
                    Logger.app.logMessage("\(#function):: Snapshot is nil", logLevel: .error)
                    completion(.failure(DatabaseError.failedToRead))
                }
            }
        }
    }

    public func sendMessage(_ text: String, to channelId: String, completion: @escaping (Error?) -> Void) {
        guard let safeId = myId else {
            Logger.app.logMessage("Cant get uuid device. ", logLevel: .error)
            completion(DatabaseError.failedToSend)
            return
        }

        let messageData: [String: Any] = [
            "content": text,
            "created": Timestamp(),
            "senderId": safeId,
            "senderName": "Dmitry Zaytcev"
        ]
        
        channels.document(channelId).collection("messages").addDocument(data: messageData) { (error) in
            if let safeError = error {
                Logger.app.logMessage("Cant send message: \(safeError.localizedDescription)", logLevel: .error)
                completion(DatabaseError.failedToSend)
            }
            completion(nil)
        }
    }
}

// MARK: - Decode
extension FirebaseManager {
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
