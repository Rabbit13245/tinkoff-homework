@testable import Финтех_чат
import XCTest

class MessageManagerTests: XCTestCase {
    func testSubscribeMessages() throws {
        let channelId = "id1"
        
        let messages = [
            Message(id: "messageId1", content: "Message1", created: Date(), senderId: "senderId", senderName: "Dima"),
            Message(id: "messageId2", content: "Message1", created: Date(), senderId: "senderId", senderName: "Dima")
        ]
        let messageData = FirebaseData<Message>(added: messages,
                                                 modified: [],
                                                 removed: [])
        
        let firebaseClientMock = FirebaseClientMock()
        firebaseClientMock.loadMessagesUpdateStub = { (completion) in
            completion(.success(messageData))
        }
        
        let coreDataClientMock = CoreDataClientMock()
        
        let messageManager = MessageManager(firebaseClient: firebaseClientMock, coreDataClient: coreDataClientMock)
        messageManager.subscribeOnChannelMessagesUpdates(channelId: channelId) { (error) in
            XCTAssertNil(error, "Error not nil!")
        }
        
        XCTAssertEqual(coreDataClientMock.messages[channelId]?.count, messages.count)
        XCTAssertEqual(firebaseClientMock.subscribeMessagesUpdatesCallsCount, 1)
    }
}
