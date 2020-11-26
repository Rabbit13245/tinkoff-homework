import Foundation

struct RequestsFactory {
    
    struct PixabayImagesRequests {
        static func topImages() -> RequestConfig<PixabayImagesParser> {
            let request = PixabayImagesRequest(apiKey: "19155253-e337d5aab4433cb5a9d3c26cc")
            return RequestConfig<PixabayImagesParser>(request: request, parser: PixabayImagesParser())
        }
        
        static func concreteImage(url: URL) -> RequestConfig<PixabayConcreteImageParser> {
            let request = PixabayConcreteImageRequest(url: url)
            
            return RequestConfig<PixabayConcreteImageParser>(request: request, parser: PixabayConcreteImageParser())
        }
    }
}
