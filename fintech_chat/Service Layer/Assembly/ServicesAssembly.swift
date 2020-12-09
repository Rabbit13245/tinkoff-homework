import Foundation

protocol IServicesAssembly {
    var messageManager: IMessageManager { get }
    var channelManager: IChannelManager { get }
    var dataManagerFactory: IDataManagerFactory { get }
    var themeManager: IThemeManager { get }
    var cameraManager: ICameraManager { get }
    var imageManager: IImageManager { get }
}

class ServicesAssembly: IServicesAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var messageManager: IMessageManager = MessageManager(
        firebaseClient: self.coreAssembly.firebaseClient,
        coreDataClient: self.coreAssembly.coreDataClient)
    
    lazy var channelManager: IChannelManager = ChannelManager(
        firebaseClient: self.coreAssembly.firebaseClient,
        coreDataClient: self.coreAssembly.coreDataClient)
    
    lazy var dataManagerFactory: IDataManagerFactory = DataManagerFactory()
    
    lazy var themeManager: IThemeManager = ThemeManager.shared
    
    lazy var cameraManager: ICameraManager = CameraManager()
    
    lazy var imageManager: IImageManager = ImageManager(requestSender: coreAssembly.requestSender)
}
