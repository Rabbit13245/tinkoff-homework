@testable import Финтех_чат
import XCTest

class ChannelManagerTests: XCTestCase {
    func testSubscribeChannels() throws {
        // given
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
        
        var blockError: Error?
        
        let channelManager = ChannelManager(firebaseClient: firebaseClientMock, coreDataClient: coreDataClientMock)
        
        // when
        channelManager.subscribeChannels { (error) in
            blockError = error
        }
        
        // then
        XCTAssertNil(blockError, "Error not nil!")
        XCTAssertEqual(coreDataClientMock.channels.count, channels.count)
        XCTAssertEqual(firebaseClientMock.subscribeChannelsUpdatesCallsCount, 1)
    }
    
    func testCreateChannel() throws {
        // given
        let channelName = "channelName"
        
        let firebaseClientMock = FirebaseClientMock()
        let coreDataClientMock = CoreDataClientMock()
        
        let channelManager = ChannelManager(firebaseClient: firebaseClientMock, coreDataClient: coreDataClientMock)
        
        var blockError: Error?
        
        // when
        channelManager.createChannel(with: channelName) { (error) in
            blockError = error
        }
        
        //then
        XCTAssertNil(blockError, "Error not nil!")
        XCTAssertEqual(firebaseClientMock.channelName, channelName)
        XCTAssertEqual(firebaseClientMock.createChannelCallsCount, 1)
    }
}
