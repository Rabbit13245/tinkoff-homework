import Foundation

protocol IImageManager {
    func loadImages(completionHandler: @escaping ((Result<[ImageApiModel], Error>) -> Void))
    
    func loadConcreteImage(url: URL, completionHandler: @escaping ((ConcreteImageApiModel?) -> Void))
}
