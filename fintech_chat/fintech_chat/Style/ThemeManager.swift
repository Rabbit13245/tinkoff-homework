import UIKit

class ThemeManager{
    
    var theme: AppTheme {
        didSet{
            guard theme != oldValue else {return}
            apply(for: UIApplication.shared)
        }
    }
    
    private static var instance: ThemeManager?
    
    static var shared: ThemeManager{
        guard let instance = self.instance else {
            let newInstance = ThemeManager(defaultTheme: .classic)
            self.instance = newInstance
            return newInstance
        }
        return instance
    }
    
    private init(defaultTheme: AppTheme){
        self.theme = defaultTheme
    }
    
    func apply(for application: UIApplication){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.settings.secondaryBackgroundColor
            appearance.titleTextAttributes = [.foregroundColor: theme.settings.labelColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: theme.settings.labelColor]
            
            //UINavigationBar.appearance().tintColor = theme.settings.labelColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        else{
            //UINavigationBar.appearance().tintColor = theme.settings.labelColor
            UINavigationBar.appearance().barTintColor = theme.settings.secondaryBackgroundColor
            UINavigationBar.appearance().isTranslucent = false
        }
        
        UITableView.appearance().backgroundColor = theme.settings.backgroundColor
        UITableView.appearance().separatorColor = theme.settings.separatorColor
        
        UITableViewCell.appearance().backgroundColor =  theme.settings.backgroundColor
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: theme.settings.labelColor]
        
        UILabel.appearance().textColor = theme.settings.labelColor
        
        AppView.appearance().backgroundColor = theme.settings.backgroundColor
        AppSeparator.appearance().backgroundColor = theme.settings.secondaryBackgroundColor
        HeaderLabel.appearance().backgroundColor = theme.settings.secondaryBackgroundColor
        
        AppImageBarButton.appearance().tintColor = UIColor.green
        
        //AppImageBarButton.appearance().foregroundColor  = UIColor.green
        
        application.windows.reload()
    }
}

extension ThemeManager: ThemeChangeDelegate{
    func changeTheme(_ theme: AppTheme) {
        self.theme = theme
    }
}
