import UIKit

class OperationDataManager {

    let nameFile = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)[0].appendingPathComponent("Name.txt")
    let descriptionFile = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)[0].appendingPathComponent("Description.txt")
    let imageFile = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)[0].appendingPathComponent("Image.png")

    private lazy var dataQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "dataOperationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

extension OperationDataManager: DataManagerProtocol {
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

    func loadImage(completion: ((_ image: UIImage?, _ error: Bool) -> Void)?) {
        let loadImageOperation = LoadImageOperation(url: self.imageFile)
        loadImageOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion?(loadImageOperation.imageResult, loadImageOperation.globalError)
            }
        }
        self.dataQueue.addOperation(loadImageOperation)
    }

    func loadUserData(completion: ((_ userData: User, _ response: Response?) -> Void)?) {
        var response = Response(nameError: false, descriptionError: false, imageError: false)
        var userData = User(userName: nil, userDescription: nil, userImage: nil)

        let loadNameOperation = LoadStringOperation(url: self.nameFile)
        self.dataQueue.addOperation(loadNameOperation)

        let loadDescriptionTask = LoadStringOperation(url: self.descriptionFile)
        self.dataQueue.addOperation(loadDescriptionTask)

        let loadImageTask = LoadImageOperation(url: self.imageFile)
        self.dataQueue.addOperation(loadImageTask)

        self.dataQueue.addOperation {

            response.nameError = loadNameOperation.globalError
            response.descriptionError = loadDescriptionTask.globalError
            response.imageError = loadImageTask.globalError

            userData.userName = loadNameOperation.stringResult
            userData.userDescription = loadDescriptionTask.stringResult
            userData.userImage = loadImageTask.imageResult

            OperationQueue.main.addOperation {
                completion?(userData, response)
            }
        }
    }

    func saveUserData(name: String?, description: String?, oldImage: UIImage?, newImage: UIImage?,
                      completion: ((_ response: Response?, _ error: Bool) -> Void)?) {
        var saveNameOperation: SaveDataOperation?
        var saveDescriptionOperation: SaveDataOperation?
        var saveImageOperation: SaveDataOperation?

        var response = Response(nameError: false, descriptionError: false, imageError: false)

        if let name = name {

            let saveNameOperationTemp = SaveStringOperation(url: self.nameFile, stringData: name)
            saveNameOperation = saveNameOperationTemp
            self.dataQueue.addOperation(saveNameOperationTemp)
        }

        if let description = description {

            let saveDescriptionOperationTemp = SaveStringOperation(url: self.descriptionFile, stringData: description)
            saveDescriptionOperation = saveDescriptionOperationTemp
            self.dataQueue.addOperation(saveDescriptionOperationTemp)
        }

        if let oldImage = oldImage,
            let newImage = newImage {

            let equalImages = oldImage.pngData() == newImage.pngData()
            if !equalImages {

                let saveImageOperationTemp = SaveImageOperation(url: self.imageFile, imageData: newImage)
                saveImageOperation = saveImageOperationTemp
                self.dataQueue.addOperation(saveImageOperationTemp)
            }
        }

        self.dataQueue.addOperation {
            let error = saveNameOperation?.globalError ?? false ||
                saveDescriptionOperation?.globalError ?? false ||
                saveImageOperation?.globalError ?? false

            response.nameError = saveNameOperation?.globalError ?? false
            response.descriptionError = saveDescriptionOperation?.globalError ?? false
            response.imageError = saveImageOperation?.globalError ?? false

            OperationQueue.main.addOperation {
                completion?(response, error)
            }
        }
    }
}
