@testable import Финтех_чат
import Foundation

class CoreDataClientMock: ICoreDataClient {
    
    var channels = [Channel]()
    var messages = [String: [Message]]()
    
    func removeDeletedChannels(ids: [String]) {
        let idsForRemove = Set(ids)
        self.channels.removeAll { (singleChannel) -> Bool in
            idsForRemove.contains(singleChannel.identifier)
        }
    }
    
    func addNewChannels(_ channels: [Channel]) {
        channels.forEach {
            self.channels.append($0)
        }
    }
    
    func modifyChannels(_ channels: [Channel]) {
        removeChannels(channels)
        addNewChannels(channels)
    }
    
    func removeChannels(_ channels: [Channel]) {
        let idsForRemove = Set(channels.map { $0.identifier })
        self.channels.removeAll { (singleChannel) -> Bool in
            idsForRemove.contains(singleChannel.identifier)
        }
    }
    
    func addNewMessages(_ messages: [Message], for channelId: String) {
        var keyExist = self.messages[channelId] != nil
        
        print(messages.count)
        
        messages.forEach {
            if !keyExist {
                self.messages[channelId] = [Message]()
                keyExist = true
            }
            self.messages[channelId]?.append($0)
        }
    }
}
