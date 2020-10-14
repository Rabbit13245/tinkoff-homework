import Foundation

class SaveStringOperation: SaveDataOperation{
    var stringData: String
    
    init(url: URL, stringData: String) {
        self.stringData = stringData
        super.init(url: url)
    }
    
    override func main() {
        guard !isCancelled else {
            Logger.app.logMessage("Cancel operation", logLevel: .Error)
            return
        }
        
        do{
            try stringData.write(to: url, atomically: true, encoding: .utf8)
        }
        catch{
            Logger.app.logMessage("Cant write data to file. \(error.localizedDescription)", logLevel: .Error)
            globalError = true
        }
    }
}
