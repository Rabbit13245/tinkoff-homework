import UIKit

class GCDDataManager{
    
    lazy var fileQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "fileQueue", qos: .utility)
        return queue
    }()
    
    let nameFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Name.txt")
    let descriptionFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Description.txt")
    let imageFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Image.png")
    
    private func loadDataFrom(url: URL, completion: ((_ name: String, _ error: Bool) -> Void)?){
        fileQueue.async {
            do{
                let strName = try String(contentsOf: url)
                
                DispatchQueue.main.async {
                    completion?(strName, false)
                }
                
            }
            catch{
                Logger.app.logMessage("Cant load data from file. \(error.localizedDescription)", logLevel: .Error)
                
                DispatchQueue.main.async {
                    completion?("", true)
                }
                
            }
        }
    }
    
    private func loadImageFrom(url: URL, completion: ((_ image: UIImage?, _ error: Bool) -> Void)?){
        fileQueue.async {
            do{
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data){
                    
                    DispatchQueue.main.async {
                        completion?(image, false)
                    }
                    
                }
            }
            catch{
                Logger.app.logMessage("Cant load image from file. \(error.localizedDescription)", logLevel: .Error)
                
                DispatchQueue.main.async {
                    completion?(nil, true)
                }
                
            }
        }
    }
    
    private func save(data: String, to url: URL, completion: ((_ error: Bool) -> Void)?){
        fileQueue.async {
            do{
                try data.write(to: url, atomically: true, encoding: .utf8)
                
                DispatchQueue.main.async {
                    completion?(false)
                }
                
            }
            catch{
                Logger.app.logMessage("Cant write data to file. \(error.localizedDescription)", logLevel: .Error)
                
                DispatchQueue.main.async {
                    completion?(true)
                }
                
            }
        }
    }
    
    init() {
        Logger.app.logMessage("GCDDataManager init", logLevel: .Info)
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
    
    func loadImage(completion: ((_ image: UIImage?, _ error: Bool) -> Void)?){
        loadImageFrom(url: self.imageFile, completion: completion)
    }
    
    func saveUserData(name: String?, description: String?, image: UIImage?, completion: ((_ response: Response?, _ error: Bool) -> Void)?){
        var globalError = false
        
        var response = Response(nameError: false, descriptionError: false, imageError: false)
        
        let dispatchGroup = DispatchGroup()
        
        if let name = name{
            
            dispatchGroup.enter()
//            fileQueue.asyncAfter(deadline: .now() + 2) {
//                do{
//                    print("Name")
//                    //try name.write(to: self.nameFile, atomically: true, encoding: .utf8)
//                    globalError = true
//                    response.nameError = true
//                }
//                catch{
//                    Logger.app.logMessage("Can`t write name to file. \(error.localizedDescription)", logLevel: .Error)
//                    globalError = true
//                    response.nameError = true
//                }
//                dispatchGroup.leave()
//            }
            
            fileQueue.async {
                do{
                    try name.write(to: self.nameFile, atomically: true, encoding: .utf8)
                }
                catch{
                    Logger.app.logMessage("Can`t write name to file. \(error.localizedDescription)", logLevel: .Error)
                    globalError = true
                    response.nameError = true
                }
                dispatchGroup.leave()
            }
        }
        
        if let description = description{
            dispatchGroup.enter()
            fileQueue.async {
                do{
                    print("Description")
                    try description.write(to: self.descriptionFile, atomically: true, encoding: .utf8)
                }
                catch{
                    Logger.app.logMessage("Can`t write description to file. \(error.localizedDescription)", logLevel: .Error)
                    globalError = true
                    response.descriptionError = true
                }
                dispatchGroup.leave()
            }
        }
        
        if let image = image{
            dispatchGroup.enter()
            fileQueue.async {
                do{
                    print("Image")
                    if let data = image.pngData(){
                        try data.write(to: self.imageFile)
                    }
                    else{
                        globalError = true
                    }
                }
                catch{
                    Logger.app.logMessage("Can`t write description to file. \(error.localizedDescription)", logLevel: .Error)
                    globalError = true
                    response.imageError = true
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: self.fileQueue) {
            DispatchQueue.main.async {
                if (globalError){
                    completion?(response, true)
                }
                    
                else{
                    completion?(nil, false)
                }
            }
        }
    }
}
