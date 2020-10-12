import Foundation


enum DataManagerType{
    case GCD
    case Operation
}

struct DataManagerFactory{
    func createDataManager(_ type: DataManagerType) -> DataManagerProtocol{
        switch type {
        case .GCD:
            return GCDDataManager()
        case .Operation:
            return OperationDataManager()
        }
    }
}
