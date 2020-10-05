import UIKit

class ThemeManager{
    
    var theme: MyTheme {
        didSet{
            guard theme != oldValue else {return}
            apply(for: UIApplication.shared)
        }
    }
    
    private static var instance: ThemeManager?
    
    static var shared: ThemeManager{
        guard let instance = self.instance else {
            let newInstance = ThemeManager(defaultTheme: .night)
            self.instance = newInstance
            return newInstance
        }
        return instance
    }
    
    private init(defaultTheme: MyTheme){
        self.theme = defaultTheme
    }
    
    func apply(for application: UIApplication){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.settings.backgroundColor
            appearance.titleTextAttributes = [.foregroundColor: theme.settings.labelColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: theme.settings.labelColor]

            UINavigationBar.appearance().tintColor = theme.settings.labelColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        else{
            UINavigationBar.appearance().tintColor = theme.settings.labelColor
            UINavigationBar.appearance().barTintColor = theme.settings.backgroundColor
            UINavigationBar.appearance().isTranslucent = false
        }
        
        UITableView.appearance().backgroundColor = theme.settings.backgroundColor
        UITableView.appearance().separatorColor = theme.settings.separatorColor
        
        
        //application.windows.forEach { $0.reload() }
//        UINavigationBar.appearance().with {
//            $0.barStyle = barStyle
//            $0.tintColor = tint
//            $0.titleTextAttributes = [
//                .foregroundColor: labelColor
//            ]
//
//            if #available(iOS 11.0, *) {
//                $0.largeTitleTextAttributes = [
//                    .foregroundColor: labelColor
//                ]
//            }
//        }
    }
}
