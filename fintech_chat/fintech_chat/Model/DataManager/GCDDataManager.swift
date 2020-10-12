import Foundation

class GCDDataManager{
    
    let fileQueue = DispatchQueue(label: "fileQueue", qos: .utility)
    
    let nameFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Name.txt")
    let descriptionFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Description.txt")
    
    private func loadDataFrom(url: URL, completion: ((_ name: String, _ error: Bool) -> Void)?){
        fileQueue.async {
            do{
                let strName = try String(contentsOf: url)
                if let completion = completion{
                    DispatchQueue.main.async {
                        completion(strName, false)
                    }
                }
                
            }
            catch{
                Logger.app.logMessage("Cant load data from file. \(error.localizedDescription)", logLevel: .Error)
                if let completion = completion{
                    DispatchQueue.main.async {
                        completion("", true)
                    }
                }
            }
        }
    }
    
    private func save(data: String, to url: URL, completion: ((_ error: Bool) -> Void)?){
        fileQueue.async {
            do{
                try data.write(to: url, atomically: true, encoding: .utf8)
                if let completion = completion{
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
            catch{
                Logger.app.logMessage("Cant write data to file. \(error.localizedDescription)", logLevel: .Error)
                if let completion = completion{
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            }
        }
    }
    
    
    
    deinit {
        Logger.app.logMessage("GCDDataManager deinit", logLevel: .Info)
    }
}

// MARK: - DataManagerProtocol

extension GCDDataManager: DataManagerProtocol{
    func loadName(completion: ((_ name: String, _ error: Bool) -> Void)?){
        loadDataFrom(url: self.nameFile, completion: completion)
    }
    
    func loadDescription(completion: ((_ description: String, _ error: Bool) -> Void)?){
        loadDataFrom(url: self.descriptionFile, completion: completion)
    }
    
    func saveUserName(_ name: String, completion: ((_ error: Bool) -> Void)?) {
        save(data: name, to: self.nameFile, completion: completion)
    }
    
    func saveUserDescription(_ description: String, completion: ((_ error: Bool) -> Void)?) {
        save(data: description, to: self.descriptionFile, completion: completion)
    }
    
    func saveUserData(name: String?, description: String?, completion: ((_ error: Bool) -> Void)?){
        if let name = name,
        let description = description{
            fileQueue.async {
                do{
                    try name.write(to: self.nameFile, atomically: true, encoding: .utf8)
                    try description.write(to: self.descriptionFile, atomically: true, encoding: .utf8)
                    if let completion = completion{
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
                catch{
                    Logger.app.logMessage("Cant write data to file. \(error.localizedDescription)", logLevel: .Error)
                    if let completion = completion{
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                }
            }
        }
        else if let name = name{
            fileQueue.async {
                do{
                    try name.write(to: self.nameFile, atomically: true, encoding: .utf8)
                    if let completion = completion{
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
                catch{
                    Logger.app.logMessage("Cant write data to file. \(error.localizedDescription)", logLevel: .Error)
                    if let completion = completion{
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                }
            }
        }
        else if let description = description{
            fileQueue.async {
                do{
                    try description.write(to: self.descriptionFile, atomically: true, encoding: .utf8)
                    if let completion = completion{
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
                catch{
                    Logger.app.logMessage("Cant write data to file. \(error.localizedDescription)", logLevel: .Error)
                    if let completion = completion{
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                }
            }
        }
    }
}
