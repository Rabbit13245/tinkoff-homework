@testable import Финтех_чат
import XCTest

class MessageManagerTests: XCTestCase {
    
    func testSubscribeMessages() throws {
        // given
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
        
        var blockError: Error?
        
        // when
        messageManager.subscribeOnChannelMessagesUpdates(channelId: channelId) { (error) in
            blockError = error
        }
        
        // then
        XCTAssertNil(blockError, "Error not nil!")
        XCTAssertEqual(coreDataClientMock.messages[channelId]?.count, messages.count)
        XCTAssertEqual(firebaseClientMock.subscribeMessagesUpdatesCallsCount, 1)
    }
    
    func testSendMessage() throws {
        // given
        let firebaseClientMock = FirebaseClientMock()
        let coreDataClientMock = CoreDataClientMock()
        
        let messageManager = MessageManager(firebaseClient: firebaseClientMock, coreDataClient: coreDataClientMock)
        
        let messageText = "messageText"
        let channeId = "channelId"

        var blockError: Error?
        
        // when
        messageManager.sendMessage(messageText, to: channeId) { (error) in
            blockError = error
        }
        
        // then
        XCTAssertNil(blockError, "Error not nil!")
        XCTAssertEqual(firebaseClientMock.messageContent, messageText)
        XCTAssertEqual(firebaseClientMock.channelId, channeId)
        XCTAssertNotNil(firebaseClientMock.userId)
        XCTAssertEqual(firebaseClientMock.sendMessageCallsCount, 1)
    }
}
