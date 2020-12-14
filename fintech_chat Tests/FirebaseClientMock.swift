@testable import Firebase
@testable import Финтех_чат
import Foundation

class FirebaseClientMock: IFirebaseClient {
    
    func getAllChannels(completion: @escaping ((Result<[Channel], Error>) -> Void)) {
        completion(.success([]))
    }
    
    var loadChannelsUpdateStub: (((Result<FirebaseData<Channel>, Error>) -> Void) -> Void)?
    var subscribeChannelsUpdatesCallsCount = 0
    func subscribeChannelsUpdates(completion: @escaping (Result<FirebaseData<Channel>, Error>) -> Void) {
        subscribeChannelsUpdatesCallsCount += 1
        loadChannelsUpdateStub?(completion)
    }
    
    var createChannelCallsCount = 0
    var channelName: String?
    func createChannel(_ channelDocument: [String: Any], completion: @escaping ((Error?) -> Void)) {
        channelName = channelDocument["name"] as? String
        createChannelCallsCount += 1
        completion(nil)
    }
    
    func removeChannel(with channelId: String, completion: @escaping ((Error?) -> Void)) {
        
    }
    
    var loadMessagesUpdateStub: (((Result<FirebaseData<Message>, Error>) -> Void) -> Void)?
    var subscribeMessagesUpdatesCallsCount = 0
    func subscribeMessagesUpdates(with channelId: String, completion: @escaping ((Result<FirebaseData<Message>, Error>) -> Void)) {
        subscribeMessagesUpdatesCallsCount += 1
        loadMessagesUpdateStub?(completion)
    }
    
    var messageContent: String?
    var userId: String?
    var channelId: String?
    var sendMessageCallsCount = 0
    func sendMessage(_ text: String, from userId: String, to channelId: String, completion: @escaping (Error?) -> Void) {
        sendMessageCallsCount += 1
        messageContent = text
        self.userId = userId
        self.channelId = channelId
        completion(nil)
    }
}
