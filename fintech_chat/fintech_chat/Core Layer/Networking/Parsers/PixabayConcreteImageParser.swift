import UIKit

struct ConcreteImageApiModel {
    let image: UIImage
}

class PixabayConcreteImageParser: IParser {
    typealias Model = ConcreteImageApiModel
    
    func parse(data: Data) -> ConcreteImageApiModel? {
        guard let image = UIImage(data: data) else {
            return nil
        }
        return ConcreteImageApiModel(image: image)
    }
}
