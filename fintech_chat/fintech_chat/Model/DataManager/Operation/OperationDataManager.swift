import UIKit

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
        let loadNameOperation = LoadStringOperation(url: self.nameFile)
        loadNameOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion?(loadNameOperation.stringResult, loadNameOperation.globalError)
            }
        }
        self.dataQueue.addOperation(loadNameOperation)
    }
    
    func loadDescription(completion: ((_ description: String, _ error: Bool) -> Void)?) {
        let loadDescriptionOperation = LoadStringOperation(url: self.descriptionFile)
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
            let saveNameOperationTemp = SaveStringOperation(url: self.nameFile, stringData: name)
            saveNameOperation = saveNameOperationTemp
            self.dataQueue.addOperation(saveNameOperationTemp)
        }
        
        if let description = description{
            print("description: \(description)")
            let saveDescriptionOperationTemp = SaveStringOperation(url: self.descriptionFile, stringData: description)
            saveDescriptionOperation = saveDescriptionOperationTemp
            self.dataQueue.addOperation(saveDescriptionOperationTemp)
        }
        
        if let image = image{
            print("Image")
            let saveImageOperationTemp = SaveImageOperation(url: self.imageFile, imageData: image)
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
