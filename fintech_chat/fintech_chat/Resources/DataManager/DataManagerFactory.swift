import Foundation

enum DataManagerType {
    case GCD
    case operation
}

struct DataManagerFactory {
    func createDataManager(_ type: DataManagerType) -> DataManagerProtocol {
        switch type {
        case .GCD:
            return GCDDataManager()
        case .operation:
            return OperationDataManager()
        }
    }
}
