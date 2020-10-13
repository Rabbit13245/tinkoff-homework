import UIKit

protocol DataManagerProtocol{
    func loadName(completion: ((_ name: String, _ error: Bool) -> Void)?)
    func loadDescription(completion: ((_ description: String, _ error: Bool) -> Void)?)
    func loadImage(completion: ((_ image: UIImage?, _ error: Bool) -> Void)?)
    
    func saveUserData(name: String?, description: String?, image: UIImage?, completion: ((_ response: Response?, _ error: Bool) -> Void)?)
}

struct Response{
    var nameError: Bool
    var descriptionError: Bool
    var imageError: Bool
}
