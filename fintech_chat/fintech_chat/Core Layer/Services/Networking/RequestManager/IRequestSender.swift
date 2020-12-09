import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

protocol IRequestSender {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model, Error>) -> Void)
}
