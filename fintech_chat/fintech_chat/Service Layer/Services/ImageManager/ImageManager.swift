import Foundation

class ImageManager: IImageManager {
    
    // MARK: - Dependencies
    
    private var requestSender: IRequestSender
    
    // MARK: - Initializers
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
        
    func loadImages(completionHandler: @escaping ((Result<[ImageApiModel], Error>) -> Void)) {
        let requestConfig = RequestsFactory.PixabayImagesRequests.topImages()
        
        requestSender.send(requestConfig: requestConfig, completionHandler: completionHandler)
    }
    
    func loadConcreteImage(url: URL, completionHandler: @escaping ((ConcreteImageApiModel?) -> Void)) {
        let requestConfig = RequestsFactory.PixabayImagesRequests.concreteImage(url: url)
        
        requestSender.send(requestConfig: requestConfig) { result in
            switch result {
            case .success(let image):
                completionHandler(image)
            case .failure:
                completionHandler(nil)
            }
        }
    }
}
