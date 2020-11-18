import Foundation

protocol IParser {
    associatedtype Model
    
    func parse(data: Data) -> Model?
}
