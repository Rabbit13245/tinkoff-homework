import Foundation

protocol DataManagerProtocol{
    func saveUserName(_ name: String, comletion: @escaping (_ error: Bool) -> Void)
    func saveUserDescription(_ description: String, comletion: @escaping (_ error: Bool) -> Void)
}
