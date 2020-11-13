import UIKit

protocol DataManagerProtocol {
    func loadName(completion: ((_ name: String, _ error: Bool) -> Void)?)
    func loadDescription(completion: ((_ description: String, _ error: Bool) -> Void)?)
    func loadImage(completion: ((_ image: UIImage?, _ error: Bool) -> Void)?)

    func loadUserData(completion: ((_ userData: User, _ response: Response?) -> Void)?)

    func saveUserData(name: String?, description: String?, oldImage: UIImage?, newImage: UIImage?,
                      completion: ((_ response: Response?, _ error: Bool) -> Void)?)
}

struct Response {
    var nameError: Bool
    var descriptionError: Bool
    var imageError: Bool
}
