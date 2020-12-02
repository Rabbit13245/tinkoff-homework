@testable import Firebase
@testable import Финтех_чат
import Foundation

class FirebaseClientMock: IFirebaseCleint {
    
    var loadChannelsUpdateStub: (((Result<FirebaseData<Channel>, Error>) -> Void) -> Void)!
    
    func getAllChannels(completion: @escaping ((Result<[Channel], Error>) -> Void)) {
        completion(.success([]))
    }
    
    var subscribeChannelsUpdatesCallsCount = 0
    func subscribeChannelsUpdates(completion: @escaping (Result<FirebaseData<Channel>, Error>) -> Void) {
        subscribeChannelsUpdatesCallsCount += 1
        loadChannelsUpdateStub(completion)
    }
    
    func createChannel(_ channelDocument: [String: Any], completion: @escaping ((Error?) -> Void)) {
        
    }
    
    func removeChannel(with channelId: String, completion: @escaping ((Error?) -> Void)) {
        
    }
    
    func subscribeMessagesUpdates(with channelId: String, completion: @escaping ((Result<FirebaseData<Message>, Error>) -> Void)) {
        
    }
    
    func sendMessage(_ text: String, from userId: String, to channelId: String, completion: @escaping (Error?) -> Void) {
        
    }
}
