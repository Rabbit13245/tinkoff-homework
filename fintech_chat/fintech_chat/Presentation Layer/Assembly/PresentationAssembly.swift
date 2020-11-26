import UIKit

protocol IPresentationAssembly {
    /// Создает нав контроллер
    func mainNavigationController() -> UINavigationController
    
    /// Создает экран со списком каналов
    func channelsListViewController() -> ChannelsListViewController
    
    /// Создает экран с сообщениями канала
    func channelViewController(channel: ChannelCellModel) -> ChannelViewController
    
    /// Создает экран с экраном настроек профиля
    func profileViewController() -> UINavigationController
    
    /// Создает экран с выбором темы
    func themesViewController() -> ThemesViewController
    
    /// Создает экран с выбором изображения для аватара
    func avatarLoadViewController(delegate: AvatarSelectDelegate?) -> UINavigationController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - NavigationColtroller
    func mainNavigationController() -> UINavigationController {
        let navVC = UINavigationController(rootViewController: channelsListViewController())
        return navVC
    }
    
    // MARK: - ChannelsListViewController
    
    func channelsListViewController() -> ChannelsListViewController {
        guard let channelsListVc = loadVCFromStoryboard(storyboardName: "Main", vcIdentifier: "ChannelsListVC") as? ChannelsListViewController else {
            fatalError("Can't load ChannelsListVC")
        }
        
        channelsListVc.setupDependencies(channelManager: serviceAssembly.channelManager,
                                         dataManagerFactory: serviceAssembly.dataManagerFactory,
                                         presentationAssembly: self)
        
        return channelsListVc
    }
    
    // MARK: - ChannelViewController
    
    func channelViewController(channel: ChannelCellModel) -> ChannelViewController {
        let channelVC = ChannelViewController(channel: channel, messageManager: serviceAssembly.messageManager)

        return channelVC
    }
    
    // MARK: - ProfileViewController
    
    func profileViewController() -> UINavigationController {
        guard let profileVC = loadVCFromStoryboard(storyboardName: "Main", vcIdentifier: "ProfileVC") as? ProfileViewController else {
            fatalError("Can't load ProfileVC")
        }
        
        profileVC.setupDependencies(cameraManager: serviceAssembly.cameraManager,
                                    dataManagerFactory: serviceAssembly.dataManagerFactory,
                                    presentationAssembly: self)
        
        let navVC = UINavigationController(rootViewController: profileVC)
        navVC.navigationBar.prefersLargeTitles = true
        
        return navVC
    }
    
    // MARK: - ThemesViewController
    
    func themesViewController() -> ThemesViewController {
        let themesVC = ThemesViewController()
        let themeManager = serviceAssembly.themeManager
        // themesVC.delegate = themeManager
        
        themesVC.changeThemeClosure = {[weak themeManager] (theme) in
            themeManager?.applyTheme(theme)
        }
        
        // themesVC.changeThemeClosure = themeManager.applyTheme
        return themesVC
    }
    
    // MARK: - AvatarLoadViewController
    
    func avatarLoadViewController(delegate: AvatarSelectDelegate?) -> UINavigationController {
        let avatarLoadVC = AvatarLoadViewController(imageManager: serviceAssembly.imageManager)
        avatarLoadVC.delegate = delegate
        let navVC = UINavigationController(rootViewController: avatarLoadVC)
        navVC.navigationBar.prefersLargeTitles = true
        
        return navVC
    }
    
    private func loadVCFromStoryboard(storyboardName: String, vcIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: vcIdentifier)
    }
}
