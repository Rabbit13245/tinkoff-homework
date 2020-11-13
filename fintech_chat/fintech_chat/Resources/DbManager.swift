import Foundation
import Firebase

public enum DatabaseError: Error {
    case failedToRead
    case failedToSend
    case failedToCreateChannel
    public var description: String {
        switch self {
        case .failedToRead:
            return "Error reading data"
            
        case .failedToSend:
            return "Error sending data"
            
        case .failedToCreateChannel:
            return "Error creating channel"
        }
    }
}

class DbManager {

    public static let shared: DbManager = {
        let dbManager = DbManager()
        return dbManager
    }()

    private init() {}

    private let channels = Firestore.firestore().collection("channels")

    let myId = UIDevice.current.identifierForVendor?.uuidString
}

// MARK: - Channels
extension DbManager {
    public func getAllChannels(completion: @escaping (Result<[Channel], Error>) -> Void) {
        channels.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Logger.app.logMessage("\(#function):: Error reading data: \(error.localizedDescription)",
                    logLevel: .error)
                completion(.failure(DatabaseError.failedToRead))
            } else {
                if let snapshot = querySnapshot {
                    completion(.success(self.parseChannels(snapshot.documents)))
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
}

// MARK: - Messages
extension DbManager {
    public func getAllMessages(from channelId: String, completion: @escaping ((Result<[Message], Error>) -> Void)) {
        channels.document(channelId).collection("messages").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Logger.app.logMessage("\(#function):: Error reading data: \(error.localizedDescription)",
                    logLevel: .error)
                completion(.failure(DatabaseError.failedToRead))
            } else {
                if let snapshot = querySnapshot {
                    completion(.success(self.parseMessages(snapshot.documents)))
                } else {
                    Logger.app.logMessage("\(#function):: Snapshot is nil", logLevel: .error)
                    completion(.failure(DatabaseError.failedToRead))
                }
            }
        }
    }

    public func sendMessage(_ text: String, to channel: String, completion: @escaping (Error?) -> Void) {
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
        
        channels.document(channel).collection("messages").addDocument(data: messageData) { (error) in
            if let safeError = error {
                Logger.app.logMessage("Cant send message: \(safeError.localizedDescription)", logLevel: .error)
                completion(DatabaseError.failedToSend)
            }
            completion(nil)
        }
    }
}

// MARK: - Decode
extension DbManager {
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
