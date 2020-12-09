import UIKit

class SaveImageOperation: SaveDataOperation {
    var imageData: UIImage

    init(url: URL, imageData: UIImage) {
        self.imageData = imageData
        super.init(url: url)
    }

    override func main() {
        guard !isCancelled else {
            Logger.app.logMessage("Cancel operation", logLevel: .error)
            return
        }
        do {
            if let data = imageData.pngData() {
                try data.write(to: url)
            } else {
                globalError = true
            }
        } catch {
            Logger.app.logMessage("Can`t write description to file. \(error.localizedDescription)", logLevel: .error)
            globalError = true
        }
    }
}
