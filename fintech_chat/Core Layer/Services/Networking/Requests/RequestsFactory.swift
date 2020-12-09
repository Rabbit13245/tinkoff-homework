import Foundation

struct RequestsFactory {
    
    struct PixabayImagesRequests {
        static func topImages() -> RequestConfig<PixabayImagesParser> {
            let apiKey = Bundle.main.infoDictionary?["PixabayApiKey"] as? String
            
            let request = PixabayImagesRequest(apiKey: apiKey)
            return RequestConfig<PixabayImagesParser>(request: request, parser: PixabayImagesParser())
        }
        
        static func concreteImage(url: URL) -> RequestConfig<PixabayConcreteImageParser> {
            let request = PixabayConcreteImageRequest(url: url)
            
            return RequestConfig<PixabayConcreteImageParser>(request: request, parser: PixabayConcreteImageParser())
        }
    }
}
