@testable import Финтех_чат
import XCTest

class ChannelManagerTests: XCTestCase {
    func testSubscribeChannels() throws {
        let channels = [
            Channel(identifier: "id1", name: "name1", lastMessage: nil, lastActivity: nil),
            Channel(identifier: "id2", name: "name2", lastMessage: "lastMessage2", lastActivity: Date())
        ]
        let channelData = FirebaseData<Channel>(added: channels,
                                                modified: [],
                                                removed: [])
        
        let firebaseClientMock = FirebaseClientMock()
        firebaseClientMock.loadChannelsUpdateStub = { (completion) in
            completion(.success(channelData))
        }
        
        let coreDataClientMock = CoreDataClientMock()
        
        let channelManager = ChannelManager(firebaseClient: firebaseClientMock, coreDataClient: coreDataClientMock)
        channelManager.subscribeChannels { (error) in
            XCTAssertNil(error, "Error not nil!")
        }
        
        XCTAssertEqual(coreDataClientMock.channels.count, channels.count)
        XCTAssertEqual(firebaseClientMock.subscribeChannelsUpdatesCallsCount, 1)
    }
}
