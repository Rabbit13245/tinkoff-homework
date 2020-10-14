import UIKit

class SaveDataOperation: Operation{
    var url: URL
    var stringData: String? = nil
    var imageData: UIImage? = nil
    
    var globalError = false
    
    init(url: URL, stringData: String) {
        self.url = url
        self.stringData = stringData
    }
    
    init(url: URL, imageData: UIImage) {
        self.url = url
        self.imageData = imageData
    }
    
    override func main() {
        guard !isCancelled else {
            Logger.app.logMessage("Cancel operation", logLevel: .Error)
            return
        }
        
        if let stringData = self.stringData{
            do{
                try stringData.write(to: url, atomically: true, encoding: .utf8)
            }
            catch{
                Logger.app.logMessage("Cant write data to file. \(error.localizedDescription)", logLevel: .Error)
                globalError = true
            }
        }
        
        if let image = self.imageData {
            do{
                if let data = image.pngData(){
                    try data.write(to: url)
                }
                else{
                    globalError = true
                }
            }
            catch{
                Logger.app.logMessage("Can`t write description to file. \(error.localizedDescription)", logLevel: .Error)
                globalError = true
            }
        }
    }
}

class BaseLoadDataOperation: Operation{
    var url: URL
    var globalError = false
    
    init(url: URL) {
        self.url = url
    }
}

class LoadStringDataOperation: BaseLoadDataOperation{
    var stringResult: String = ""
    
    override func main() {
        guard !isCancelled else {return}
                
        do{
            stringResult = try String(contentsOf: url)
        }
        catch{
            Logger.app.logMessage("Cant load data from file. \(error.localizedDescription)", logLevel: .Error)
        }
    }
}

class LoadImageOperation: BaseLoadDataOperation{
    var imageResult: UIImage? = nil
    
    override func main() {
        guard !isCancelled else {return}
        
        do{
            let data = try Data(contentsOf: url)
            imageResult = UIImage(data: data)
        }
        catch{
            Logger.app.logMessage("Cant load image from file. \(error.localizedDescription)", logLevel: .Error)
        }
    }
}

class OperationDataManager{
    
    let nameFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Name.txt")
    let descriptionFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Description.txt")
    let imageFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Image.png")
    
    private lazy var dataQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "dataOperationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    init() {
        Logger.app.logMessage("OperationDataManager init", logLevel: .Info)
    }
    
    deinit {
        Logger.app.logMessage("OperationDataManager deinit", logLevel: .Info)
    }
}

extension OperationDataManager: DataManagerProtocol{
    func loadName(completion: ((_ name: String, _ error: Bool) -> Void)?) {
        let loadNameOperation = LoadStringDataOperation(url: self.nameFile)
        loadNameOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion?(loadNameOperation.stringResult, loadNameOperation.globalError)
            }
        }
        self.dataQueue.addOperation(loadNameOperation)
    }
    
    func loadDescription(completion: ((_ description: String, _ error: Bool) -> Void)?) {
        let loadDescriptionOperation = LoadStringDataOperation(url: self.descriptionFile)
        loadDescriptionOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion?(loadDescriptionOperation.stringResult, loadDescriptionOperation.globalError)
            }
        }
        self.dataQueue.addOperation(loadDescriptionOperation)
    }
    
    func loadImage(completion: ((_ image: UIImage?, _ error: Bool) -> Void)?){
        let loadImageOperation = LoadImageOperation(url: self.imageFile)
        loadImageOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion?(loadImageOperation.imageResult, loadImageOperation.globalError)
            }
        }
        self.dataQueue.addOperation(loadImageOperation)
    }
    
    func saveUserData(name: String?, description: String?, image: UIImage?, completion: ((_ response: Response?, _ error: Bool) -> Void)?){
        var saveNameOperation: SaveDataOperation? = nil
        var saveDescriptionOperation: SaveDataOperation? = nil
        var saveImageOperation: SaveDataOperation? = nil
        
        var response = Response(nameError: false, descriptionError: false, imageError: false)
        
        if let name = name{
            print("name: \(name)")
            let saveNameOperationTemp = SaveDataOperation(url: self.nameFile, stringData: name)
            saveNameOperation = saveNameOperationTemp
            self.dataQueue.addOperation(saveNameOperationTemp)
        }
        
        if let description = description{
            print("description: \(description)")
            let saveDescriptionOperationTemp = SaveDataOperation(url: self.descriptionFile, stringData: description)
            saveDescriptionOperation = saveDescriptionOperationTemp
            self.dataQueue.addOperation(saveDescriptionOperationTemp)
        }
        
        if let image = image{
            print("Image")
            let saveImageOperationTemp = SaveDataOperation(url: self.imageFile, imageData: image)
            saveImageOperation = saveImageOperationTemp
            self.dataQueue.addOperation(saveImageOperationTemp)
        }
                
        self.dataQueue.addOperation {
            let error = saveNameOperation?.globalError ?? false || saveDescriptionOperation?.globalError ?? false || saveImageOperation?.globalError ?? false
            
            response.nameError = saveNameOperation?.globalError ?? false
            response.descriptionError = saveDescriptionOperation?.globalError ?? false
            response.imageError = saveImageOperation?.globalError ?? false
            
            OperationQueue.main.addOperation {
                completion?(response, error)
            }
        }
    }
}
