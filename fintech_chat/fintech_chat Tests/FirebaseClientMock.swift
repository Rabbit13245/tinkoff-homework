@testable import Firebase
@testable import Финтех_чат
import Foundation

class FirebaseClientMock: IFirebaseCleint {
    
    func getAllChannels(completion: @escaping ((Result<[Channel], Error>) -> Void)) {
        completion(.success([]))
    }
    
    var loadChannelsUpdateStub: (((Result<FirebaseData<Channel>, Error>) -> Void) -> Void)!
    var subscribeChannelsUpdatesCallsCount = 0
    func subscribeChannelsUpdates(completion: @escaping (Result<FirebaseData<Channel>, Error>) -> Void) {
        subscribeChannelsUpdatesCallsCount += 1
        loadChannelsUpdateStub(completion)
    }
    
    func createChannel(_ channelDocument: [String: Any], completion: @escaping ((Error?) -> Void)) {
        
    }
    
    func removeChannel(with channelId: String, completion: @escaping ((Error?) -> Void)) {
        
    }
    
    var loadMessagesUpdateStub: (((Result<FirebaseData<Message>, Error>) -> Void) -> Void)!
    var subscribeMessagesUpdatesCallsCount = 0
    func subscribeMessagesUpdates(with channelId: String, completion: @escaping ((Result<FirebaseData<Message>, Error>) -> Void)) {
        subscribeMessagesUpdatesCallsCount += 1
        loadMessagesUpdateStub(completion)
    }
    
    func sendMessage(_ text: String, from userId: String, to channelId: String, completion: @escaping (Error?) -> Void) {
        
    }
}
