import Foundation

protocol IChannelManager {
    // func getChannel(with id: String, in context: NSManagedObjectContext? = nil) -> ChannelDb?
    func getChannel(with id: String) -> ChannelDb?
    
    /// Добавить новые каналы
    func addNewChannels(_ channels: [Channel])
    
    /// Обновить существующие каналы
    func modifyChannels(_ channels: [Channel])
    
    /// Удалить каналы
    func removeChannels(_ channels: [Channel])
    
    /// Удалить старты каналы
    func removeOldChannels(_ channels: [Channel])
}
