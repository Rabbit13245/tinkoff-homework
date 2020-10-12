import Foundation

struct OperationDataManager{
    
}

extension OperationDataManager: DataManagerProtocol{
    func loadName(completion: ((_ name: String, _ error: Bool) -> Void)?) {
        return
    }
    
    func loadDescription(completion: ((_ description: String, _ error: Bool) -> Void)?) {
        return
    }
    
    func saveUserName(_ name: String, completion: ((_ error: Bool) -> Void)?) {
        return
    }
    
    func saveUserDescription(_ description: String, completion: ((_ error: Bool) -> Void)?) {
        return
    }
    
    func saveUserData(name: String?, description: String?, completion: ((_ error: Bool) -> Void)?){
        return
    }
    
}
