import Foundation
import Firebase

/// Клиент для работы с firebase
protocol IFirebaseCleint {
    /// Получить все каналы
    func getAllChannels(completion: @escaping ((Result<[Channel], Error>) -> Void))
    
    /// Подписаться на обновления каналов
    func subscribeChannelsUpdates(completion: @escaping (Result<FirebaseData<Channel>, Error>) -> Void)
    
    /// Создать канал
    func createChannel(_ channelDocument: [String: Any], completion: @escaping ((Error?) -> Void))
    
    /// Удалить канал
    func removeChannel(with channelId: String, completion: @escaping ((Error?) -> Void))
    
    /// Подписаться на обновления сообщений в канале
    func subscribeMessagesUpdates(with channelId: String, completion: @escaping ((Result<FirebaseData<Message>, Error>) -> Void))
    
    /// Отправить сообщение
    func sendMessage(_ text: String, from userId: String, to channelId: String, completion: @escaping (Error?) -> Void)
}
