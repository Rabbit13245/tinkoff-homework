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
    
    private let database = Firestore.firestore()
}

// MARK: - Channels
extension DbManager{
    public func getAllChannels(completion: @escaping (Result<[Channel], Error>) -> Void){
        database.collection("channels").getDocuments { (querySnapshot, error) in
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
}

// MARK:- decode
extension DbManager{
    private func parseChannels(_ documents: [QueryDocumentSnapshot]) -> [Channel]{
        return documents.compactMap{Channel($0)}
    }
}
