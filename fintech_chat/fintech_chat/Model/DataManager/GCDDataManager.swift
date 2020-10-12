import Foundation

class GCDDataManager{
    
    let fileQueue = DispatchQueue(label: "fileQueue", qos: .utility)
    let nameFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Name.txt")
    let descriptionFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Description.txt")
    
    func loadName(completion: @escaping (_ name: String, _ error: Bool) -> Void){
        fileQueue.async {
            do{
                let strName = try String(contentsOf: self.nameFile)
                DispatchQueue.main.async {
                    completion(strName, false)
                }
            }
            catch{
                Logger.app.logMessage("Cant load name form file. \(error.localizedDescription)", logLevel: .Error)
                DispatchQueue.main.async {
                    completion("", true)
                }
            }
        }
    }
}

extension GCDDataManager: DataManagerProtocol{
    func saveUserName(_ name: String, comletion: @escaping (_ error: Bool) -> Void) {
        
        fileQueue.async {
            do{
                try name.write(to: self.nameFile, atomically: true, encoding: .utf8)
                DispatchQueue.main.async {
                    comletion(false)
                }
            }
            catch{
                Logger.app.logMessage("\(error.localizedDescription)", logLevel: .Error)
                DispatchQueue.main.async {
                    comletion(true)
                }
            }
        }
    }
    
    func saveUserDescription(_ description: String, comletion: @escaping (_ error: Bool) -> Void) {
        fileQueue.async {
            do{
                try description.write(to: self.descriptionFile, atomically: true, encoding: .utf8)
                DispatchQueue.main.async {
                    comletion(false)
                }
            }
            catch{
                Logger.app.logMessage("\(error.localizedDescription)", logLevel: .Error)
                DispatchQueue.main.async {
                    comletion(true)
                }
            }
        }
    }
}
