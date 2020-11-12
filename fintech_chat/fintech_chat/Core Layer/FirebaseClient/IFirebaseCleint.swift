import Foundation
import Firebase

/// Клиент для работы с firebase
protocol IFirebaseCleint {
    /// Получить все каналы
    func getAllChannels(completion: @escaping ((Result<[Channel], Error>) -> Void))
    
    /// Создать канал
    func createChannel(_ channelDocument: [String: Any], completion: @escaping ((Error?) -> Void))
    
    /// Удалить канал
    func removeChannel(with channelId: String, completion: @escaping ((Error?) -> Void))
    
    /// Получить все сообщения
    func getAllMessages(from channelId: String, completion: @escaping ((Result<[DocumentChange], Error>) -> Void))
    
    /// Отправить сообщение
    func sendMessage(_ messageData: [String: Any], to channelId: String, completion: @escaping (Error?) -> Void)
}
