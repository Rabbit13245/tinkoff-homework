import Foundation

protocol DataManagerProtocol{
    func loadName(completion: ((_ name: String, _ error: Bool) -> Void)?)
    func loadDescription(completion: ((_ description: String, _ error: Bool) -> Void)?)
    
    func saveUserName(_ name: String, completion: ((_ error: Bool) -> Void)?)
    func saveUserDescription(_ description: String, completion: ((_ error: Bool) -> Void)?)
    
    func saveUserData(name: String?, description: String?, completion: ((_ error: Bool) -> Void)?)
}
