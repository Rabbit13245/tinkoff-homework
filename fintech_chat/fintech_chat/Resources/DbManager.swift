import Foundation
import Firebase

public enum DatabaseError: Error {
    case failedToRead
    
    public var description: String {
        switch self {
        case .failedToFetch:
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
                    print(snapshot.documents.count)
                }
                else{
                    Logger.app.logMessage("\(#function):: Snapshot is nil", logLevel: .Error)
                    completion(.failure(DatabaseError.failedToRead))
                }
            }
        }
    }
}
