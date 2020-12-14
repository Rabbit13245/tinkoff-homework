import Foundation

/// Клиент для работы с coredata
protocol ICoreDataClient {
    
    /// Удалить каналы, что были удалены в фаербейс
    func removeDeletedChannels(ids: [String])
    
    /// Добавить новые каналы
    func addNewChannels(_ channels: [Channel])
    
    /// Обновить существующие каналы
    func modifyChannels(_ channels: [Channel])
    
    /// Удалить каналы
    func removeChannels(_ channels: [Channel])
    
    /// Добавить новые сообщения
    func addNewMessages(_ messages: [Message], for channelId: String)
}
