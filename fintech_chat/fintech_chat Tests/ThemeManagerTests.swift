@testable import Финтех_чат
import XCTest

class ThemeManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let channel = Channel(identifier: "id1", name: "name1", lastMessage: nil, lastActivity: nil)
        let message = Message(id: "idMessage1", content: "Hellow world", created: Date(), senderId: "senderId", senderName: "Dima")
        
        let coreDataClientMock = CoreDataClientMock()
        coreDataClientMock.addNewChannels([channel])

        coreDataClientMock.addNewMessages([message], for: "id1")
        
        print(coreDataClientMock.messages)
        
        XCTAssertEqual(coreDataClientMock.channels.count, 1)
        XCTAssertEqual(coreDataClientMock.messages.count, 1)
    }
}
