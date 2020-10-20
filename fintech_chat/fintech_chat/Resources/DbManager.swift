import Foundation
import Firebase

public enum DatabaseError: Error {
    case failedToRead
    
    public var description: String {
        switch self {
        case .failedToRead:
            return "Error reading data"
        }
    }
}

class DbManager{
    
    public static let shared: DbManager = {
        let dbManager = DbManager()
        return dbManager
    }()
    
    private init(){}
    
    private let channels = Firestore.firestore().collection("channels")
    
    let myId = UIDevice.current.identifierForVendor?.uuidString
}

// MARK: - Channels
extension DbManager{
    public func getAllChannels(completion: @escaping (Result<[Channel], Error>) -> Void){
        channels.addSnapshotListener{ (querySnapshot, error) in
            if let error = error{
                Logger.app.logMessage("\(#function):: Error reading data: \(error.localizedDescription)", logLevel: .Error)
                completion(.failure(DatabaseError.failedToRead))
            } else{
                if let snapshot = querySnapshot {
                    completion(.success(self.parseChannels(snapshot.documents)))
                }
                else{
                    Logger.app.logMessage("\(#function):: Snapshot is nil", logLevel: .Error)
                    completion(.failure(DatabaseError.failedToRead))
                }
            }
        }
    }
    
    public func createChannel(with name: String){
        
    }
}

// MARK: - Messages
extension DbManager{
    public func getAllMessages(from channelId: String, completion: @escaping ((Result<[Message], Error>) -> Void)){
        channels.document(channelId).collection("messages").addSnapshotListener { (querySnapshot, error) in
            if let error = error{
                Logger.app.logMessage("\(#function):: Error reading data: \(error.localizedDescription)", logLevel: .Error)
                completion(.failure(DatabaseError.failedToRead))
            }
            else{
                if let snapshot = querySnapshot{
                    completion(.success(self.parseMessages(snapshot.documents)))
                }
                else{
                    Logger.app.logMessage("\(#function):: Snapshot is nil", logLevel: .Error)
                    completion(.failure(DatabaseError.failedToRead))
                }
            }
        }
    }
    
    public func sendMessage(_ text: String, to channel: String){
        guard let safeId = myId else {
            Logger.app.logMessage("Cant get uuid device. ", logLevel: .Error)
            return
        }
        
        let messageData:[String: Any] = [
            "content": text,
            "created": Timestamp(),
            "senderId": safeId,
            "senderName": "Dmitry Zaytcev"
        ]
        channels.document(channel).collection("messages").addDocument(data: messageData)
    }
}

// MARK:- Decode
extension DbManager{
    private func parseChannels(_ documents: [QueryDocumentSnapshot]) -> [Channel]{
        return documents.compactMap{Channel($0)}
    }
    
    private func parseMessages(_ documents: [QueryDocumentSnapshot]) -> [Message]{
        return documents.compactMap{Message($0)}
    }
}
