import CoreData

protocol IMessageManager {
    
    /// Подписаться на обновления сообщений в канале
    func subscribeOnChannelMessagesUpdates(channelId: String, completion: @escaping ((Error?) -> Void))
    
    /// Отправить сообщение в канал
    func sendMessage(_ text: String, to channelId: String, completion: @escaping ((Error?) -> Void))
}
