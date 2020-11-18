import Foundation

struct ImageApiModel: Codable {
    let id: Int
    let webformatURL: String
}

struct AnswerApiModel: Codable {
    let total: Int
    let hits: [ImageApiModel]
}

class PixabayImagesParser: IParser {
    typealias Model = [ImageApiModel]
    
    func parse(data: Data) -> [ImageApiModel]? {
        do {
            let decodedData = try JSONDecoder().decode(AnswerApiModel.self, from: data)
            return decodedData.hits
        } catch {
            Logger.app.logMessage("decode error: \(error.localizedDescription)", logLevel: .error)
            return nil
        }
    }
}
