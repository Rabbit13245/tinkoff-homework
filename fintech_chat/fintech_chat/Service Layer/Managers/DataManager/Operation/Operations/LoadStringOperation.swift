import Foundation

class LoadStringOperation: LoadDataOperation {
    var stringResult: String = ""

    override func main() {
        guard !isCancelled else {return}

        do {
            stringResult = try String(contentsOf: url)
        } catch {
            Logger.app.logMessage("Cant load data from file. \(error.localizedDescription)", logLevel: .error)
        }
    }
}
