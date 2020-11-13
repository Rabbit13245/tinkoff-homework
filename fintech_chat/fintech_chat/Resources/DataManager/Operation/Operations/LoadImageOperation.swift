import UIKit

class LoadImageOperation: LoadDataOperation {
    var imageResult: UIImage?

    override func main() {
        guard !isCancelled else {return}

        do {
            let data = try Data(contentsOf: url)
            imageResult = UIImage(data: data)
        } catch {
            Logger.app.logMessage("Cant load image from file. \(error.localizedDescription)", logLevel: .error)
        }
    }
}
