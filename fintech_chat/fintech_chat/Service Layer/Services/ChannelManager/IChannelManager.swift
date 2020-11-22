import Foundation

protocol IChannelManager {
    
    /// Подписаться на обновления каналов из firebase
    func subscribeChannels(completion: @escaping ((Error?) -> Void))
    
    /// Создать канал
    func createChannel(with name: String, completion: @escaping ((Error?) -> Void))
    
    /// Удалить канал 
    func removeChannel(_ channelId: String, completion: @escaping ((Error?) -> Void))
}
