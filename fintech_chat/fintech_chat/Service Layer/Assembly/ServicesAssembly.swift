import Foundation

protocol IServicesAssembly {
    var messageManager: IMessageManager { get }
    var channelManager: IChannelManager { get }
    var dataManagerFactory: IDataManagerFactory { get }
    var themeManager: IThemeManager { get }
}

class ServicesAssembly: IServicesAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var messageManager: IMessageManager = MessageManager(firebaseClient: self.coreAssembly.firebaseClient)
    
    lazy var channelManager: IChannelManager = ChannelManager(firebaseClient: self.coreAssembly.firebaseClient)
    
    lazy var dataManagerFactory: IDataManagerFactory = DataManagerFactory()
    
    lazy var themeManager: IThemeManager = ThemeManager.shared
}
