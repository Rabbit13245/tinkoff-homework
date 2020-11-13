import Foundation

class LoadDataOperation: Operation {
    var url: URL
    var globalError = false

    init(url: URL) {
        self.url = url
    }
}
