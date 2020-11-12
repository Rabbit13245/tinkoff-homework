import Foundation

class CoreDataClient: ICoreDataClient {
    
    // MARK: - Dependencies
    
    private let coreDataStack = CoreDataStack()
    
    init() {
        coreDataStack.enableObservers()
    }
}
