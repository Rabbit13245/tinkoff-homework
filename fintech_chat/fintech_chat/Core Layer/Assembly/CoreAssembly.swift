import Foundation

protocol ICoreAssembly {
    var firebaseClient: IFirebaseCleint { get }
    var coreDataClient: ICoreDataClient { get }
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var firebaseClient: IFirebaseCleint = FirebaseCleint()
    lazy var coreDataClient: ICoreDataClient = CoreDataClient()
    lazy var requestSender: IRequestSender = RequestSender()
}
