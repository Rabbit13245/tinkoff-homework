import Foundation

class PixabayConcreteImageRequest: IRequest {
    
    // MARK: - Private properties
    
    private let url: URL
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        return URLRequest(url: url)
    }
    
    // MARK: - Initializers
    
    init(url: URL) {
        self.url = url
    }
}
