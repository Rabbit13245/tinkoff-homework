import Foundation

struct DataManagerFactory: IDataManagerFactory {
    func createDataManager(_ type: DataManagerType) -> IDataManager {
        switch type {
        case .GCD:
            return GCDDataManager()
        case .operation:
            return OperationDataManager()
        }
    }
}
