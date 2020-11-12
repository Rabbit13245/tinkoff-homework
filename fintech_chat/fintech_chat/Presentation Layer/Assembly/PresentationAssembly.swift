import UIKit

protocol IPresentationAssembly {
    /// Создает экран со списком каналов
    func channelsListViewController() -> ChannelsListViewController
    
    /// Создает экран с сообщениями канала
    func channelViewController() -> ChannelViewController
    
    /// Создает экран с экраном настроек профиля
    func profileViewController() -> ProfileViewController
    
    /// Создает экран с выбором темы
    func themesViewController() -> ThemesViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - ChannelsListViewController
    
    func channelsListViewController() -> ChannelsListViewController {
        guard let channelsListVc = loadVCFromStoryboard(storyboardName: "Main", vcIdentifier: "ChannelsListVC") as? ChannelsListViewController else {
            fatalError("Can't load ChannelsListVC")
        }
        
        return channelsListVc
    }
    
    // MARK: - ChannelViewController
    
    func channelViewController() -> ChannelViewController {
//        let channelVC = channelViewController()
//
//        return channelVC
        return channelViewController()
    }
    
    // MARK: - ProfileViewController
    
    func profileViewController() -> ProfileViewController {
        guard let profileVC = loadVCFromStoryboard(storyboardName: "Main", vcIdentifier: "ProfileVC") as? ProfileViewController else {
            fatalError("Can't load ProfileVC")
        }
        
        return profileVC
    }
    
    // MARK: - ThemesViewController
    
    func themesViewController() -> ThemesViewController {
        let themesVC = themesViewController()
        
        return themesVC
    }
    
    private func loadVCFromStoryboard(storyboardName: String, vcIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: vcIdentifier)
    }
}
