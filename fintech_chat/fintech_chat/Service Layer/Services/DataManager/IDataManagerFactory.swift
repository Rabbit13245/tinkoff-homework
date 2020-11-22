import Foundation

protocol IDataManagerFactory {
    func createDataManager(_ type: DataManagerType) -> IDataManager
}

enum DataManagerType {
    case GCD
    case operation
}
