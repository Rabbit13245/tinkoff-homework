import Foundation

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model, Error>) -> Void) {
        guard let urlRequest = requestConfig.request.urlRequest else {
            // completionHandler(.failure())
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, _, errorRequest) in
            if let errorRequest = errorRequest {
                completionHandler(.failure(errorRequest))
                return
            }
            
            guard let data = data,
                  let decodedData = requestConfig.parser.parse(data: data) else { return }
            
            completionHandler(.success(decodedData))
        }
        task.resume()
    }
}
