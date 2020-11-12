import Foundation

protocol IChannelManager {
    
    // func getChannel(with id: String, in context: NSManagedObjectContext? = nil) -> ChannelDb?
    
    /// Получить канал по id
    func getChannel(with id: String) -> ChannelDb?
    
    /// Подписаться на обновления каналов из firebase
    func subscribeChannels()
    
    /// Создать канал
    func createChannel(with name: String, completion: @escaping ((Error?) -> Void))
    
    /// Удалить канал 
    func removeChannel(_ channelId: String, completion: @escaping ((Error?) -> Void))
}
