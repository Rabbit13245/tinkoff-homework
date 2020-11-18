import Foundation

// https://pixabay.com/api/?key=19155253-e337d5aab4433cb5a9d3c26cc&q=yellow+flowers&image_type=photo&pretty=true&per_page=100

class PixabayImagesRequest: IRequest {
    
    // MARK: - Private properties
    
    private let baseUrl: String = "https://pixabay.com/api/?image_type=photo&pretty=true&"
    private let photoDescription = "cats"
    private let photosPerPage = 200
    private let apiKey: String
    
    private var getParameters: [String: String] {
        return [
            "q": photoDescription,
            "per_page": String(photosPerPage),
            "key": apiKey
        ]
    }
    
    private var urlString: String {
        let getParams = getParameters.compactMap({"\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + getParams
    }
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    // MARK: - Initializers
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
