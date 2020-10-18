import Foundation

class SaveDataOperation: Operation{
    var url: URL
    
    var globalError = false
    
    init(url: URL){
        self.url = url
    }
}


