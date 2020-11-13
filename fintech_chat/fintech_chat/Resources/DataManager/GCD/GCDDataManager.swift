import UIKit

class GCDDataManager {

    lazy var fileQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "fileQueue", qos: .utility)
        return queue
    }()

    let nameFile = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent("Name.txt")
    let descriptionFile = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask)[0].appendingPathComponent("Description.txt")
    let imageFile = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)[0].appendingPathComponent("Image.png")

    private func loadDataFrom(url: URL, completion: ((_ name: String, _ error: Bool) -> Void)?) {
        //fileQueue.asyncAfter(deadline: .now() + 5){
        fileQueue.async {
            do {
                let strName = try String(contentsOf: url)

                DispatchQueue.main.async {
                    completion?(strName, false)
                }
            } catch {
                Logger.app.logMessage("Cant load data from file. \(error.localizedDescription)", logLevel: .error)

                DispatchQueue.main.async {
                    completion?("", true)
                }
            }
        }
    }

    private func loadImageFrom(url: URL, completion: ((_ image: UIImage?, _ error: Bool) -> Void)?) {

        //fileQueue.asyncAfter(deadline: .now() + 5){
        fileQueue.async {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {

                    DispatchQueue.main.async {
                        completion?(image, false)
                    }

                }
            } catch {
                Logger.app.logMessage("Cant load image from file. \(error.localizedDescription)", logLevel: .error)

                DispatchQueue.main.async {
                    completion?(nil, true)
                }

            }
        }
    }

    private func save(data: String, to url: URL, completion: ((_ error: Bool) -> Void)?) {
        fileQueue.async {
            do {
                try data.write(to: url, atomically: true, encoding: .utf8)

                DispatchQueue.main.async {
                    completion?(false)
                }

            } catch {
                Logger.app.logMessage("Cant write data to file. \(error.localizedDescription)", logLevel: .error)

                DispatchQueue.main.async {
                    completion?(true)
                }

            }
        }
    }
}

// MARK: - DataManagerProtocol

extension GCDDataManager: DataManagerProtocol {
    func loadName(completion: ((_ name: String, _ error: Bool) -> Void)?) {
        loadDataFrom(url: self.nameFile, completion: completion)
    }

    func loadDescription(completion: ((_ description: String, _ error: Bool) -> Void)?) {
        loadDataFrom(url: self.descriptionFile, completion: completion)
    }

    func loadImage(completion: ((_ image: UIImage?, _ error: Bool) -> Void)?) {
        loadImageFrom(url: self.imageFile, completion: completion)
    }

    func loadUserData(completion: ((_ userData: User, _ response: Response?) -> Void)?) {
        var response = Response(nameError: false, descriptionError: false, imageError: false)

        let dispatchGroup = DispatchGroup()

        var userData = User(userName: nil, userDescription: nil, userImage: nil)
        dispatchGroup.enter()
        //fileQueue.asyncAfter(deadline: .now() + 5){
        fileQueue.async {
            do {
                let name = try String(contentsOf: self.nameFile)
                userData.userName = name
            } catch {
                Logger.app.logMessage("Cant load data from file. \(error.localizedDescription)", logLevel: .error)
                response.nameError = true
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        //fileQueue.asyncAfter(deadline: .now() + 5){
        fileQueue.async {
            do {
                let description = try String(contentsOf: self.descriptionFile)
                userData.userDescription = description
            } catch {
                Logger.app.logMessage("Cant load data from file. \(error.localizedDescription)", logLevel: .error)
                response.descriptionError = true
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        //fileQueue.asyncAfter(deadline: .now() + 5){
        fileQueue.async {
            do {
                let data = try Data(contentsOf: self.imageFile)
                if let image = UIImage(data: data) {
                    userData.userImage = image
                }
            } catch {
                Logger.app.logMessage("Cant load image from file. \(error.localizedDescription)", logLevel: .error)
                response.imageError = true
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: self.fileQueue) {
            DispatchQueue.main.async {
                completion?(userData, response)
            }
        }
    }

    func saveUserData(name: String?, description: String?, oldImage: UIImage?, newImage: UIImage?,
                      completion: ((_ response: Response?, _ error: Bool) -> Void)?) {
        var globalError = false
        var response = Response(nameError: false, descriptionError: false, imageError: false)
        let dispatchGroup = DispatchGroup()

        if let name = name {
            dispatchGroup.enter()
            fileQueue.async {
                do {
                    try name.write(to: self.nameFile, atomically: true, encoding: .utf8)
                } catch {
                    Logger.app.logMessage("Can`t write name to file. \(error.localizedDescription)", logLevel: .error)
                    globalError = true
                    response.nameError = true
                }
                dispatchGroup.leave()
            }
        }

        if let description = description {
            dispatchGroup.enter()
            fileQueue.async {
                do {
                    try description.write(to: self.descriptionFile, atomically: true, encoding: .utf8)
                } catch {
                    Logger.app.logMessage("Can`t write description to file. \(error.localizedDescription)",
                        logLevel: .error)
                    globalError = true
                    response.descriptionError = true
                }
                dispatchGroup.leave()
            }
        }

        if let oldImage = oldImage,
            let newImage = newImage {
            dispatchGroup.enter()
            fileQueue.async {
                let equalImages = oldImage.pngData() == newImage.pngData()
                if !equalImages {
                    do {
                        if let data = newImage.pngData() {
                            try data.write(to: self.imageFile)
                        } else {
                            globalError = true
                        }
                    } catch {
                        Logger.app.logMessage("Can`t write description to file. \(error.localizedDescription)",
                            logLevel: .error)
                        globalError = true
                        response.imageError = true
                    }
                }
                dispatchGroup.leave()
            }
        }
        if let newImage = newImage,
            oldImage == nil {
            dispatchGroup.enter()
            fileQueue.async {
                do {
                    if let data = newImage.pngData() {
                        try data.write(to: self.imageFile)
                    } else {
                        globalError = true
                    }
                } catch {
                    Logger.app.logMessage("Can`t write description to file. \(error.localizedDescription)",
                        logLevel: .error)
                    globalError = true
                    response.imageError = true
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: self.fileQueue) {
            DispatchQueue.main.async {
                if globalError {
                    completion?(response, true)
                } else {
                    completion?(response, false)
                }
            }
        }
    }
}
