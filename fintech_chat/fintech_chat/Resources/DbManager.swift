import Foundation
import Firebase

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
    public func getAllChannels(){
        database.collection("channels").getDocuments { (querySnapshot, error) in
            if let error = error{
                print("Fuck you")
            } else{
                if let snapshot = querySnapshot {
                    print(snapshot.documents.count)
                }
                else{
                    print("empty")
                }
            }
        }
    }
}
