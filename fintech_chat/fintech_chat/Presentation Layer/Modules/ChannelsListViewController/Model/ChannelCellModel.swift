import UIKit

struct ChannelCellModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init(_ channel: Channel) {
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
    
    init(_ channelDb: ChannelDb) {
        self.identifier = channelDb.identifier
        self.name = channelDb.name
        self.lastMessage = channelDb.lastMessage
        self.lastActivity = channelDb.lastActivity
    }
}
