import Foundation

protocol ICoreAssembly {
    var firebaseClient: IFirebaseClient { get }
    var coreDataClient: ICoreDataClient { get }
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var firebaseClient: IFirebaseClient = FirebaseClient()
    lazy var coreDataClient: ICoreDataClient = CoreDataClient()
    lazy var requestSender: IRequestSender = RequestSender()
}
