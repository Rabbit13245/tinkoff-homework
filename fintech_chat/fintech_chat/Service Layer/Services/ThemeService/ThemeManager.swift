import UIKit

class ThemeManager: ThemeManagerProtocol {

    // MARK: - Private properties
    
    private let selectedThemeKey = "SelectedTheme"

    // MARK: - Singletone
    
    private static var instance: ThemeManager?

    static var shared: ThemeManager {
        guard let instance = self.instance else {
            let themeForApply = AppTheme(rawValue: UserDefaults.standard.integer(forKey: "SelectedTheme")) ?? .classic
            let newInstance = ThemeManager(defaultTheme: themeForApply)
            self.instance = newInstance
            return newInstance
        }
        return instance
    }

    private init(defaultTheme: AppTheme) {
        self.theme = defaultTheme
    }
    
    // MARK: - Public properties
    
    var theme: AppTheme {
        didSet {
            guard theme != oldValue else { return }

            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                UserDefaults.standard.setValue(self.theme.rawValue, forKey: self.selectedThemeKey)

                DispatchQueue.main.async {
                    self.apply(for: UIApplication.shared)
                }
            }
        }
    }

    // MARK: - Private methods
    
    func apply(for application: UIApplication) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.settings.secondaryBackgroundColor
            appearance.titleTextAttributes = [.foregroundColor: theme.settings.labelColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: theme.settings.labelColor]

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = theme.settings.secondaryBackgroundColor
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: theme.settings.labelColor]
            UINavigationBar.appearance().largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: theme.settings.labelColor]
        }

        UITableView.appearance().backgroundColor = theme.settings.backgroundColor
        UITableView.appearance().separatorColor = theme.settings.separatorColor
        UITableView.appearance().indicatorStyle = theme.settings.indicatorStyle

        UITableViewCell.appearance().backgroundColor = theme.settings.backgroundColor

        UITextView.appearance().backgroundColor = theme.settings.backgroundColor
        UITextView.appearance().textColor = theme.settings.labelColor

        UITextField.appearance().defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.settings.labelColor]

        UIActivityIndicatorView.appearance().color = theme.settings.labelColor

        AppView.appearance().backgroundColor = theme.settings.backgroundColor
        AppSeparator.appearance().backgroundColor = theme.settings.secondaryBackgroundColor
        AppTextWrapperView.appearance().backgroundColor = theme.settings.textWrapperBackgroundColor

        AppThemesView.appearance().backgroundColor = theme.settings.outputMessageBackgroundColor

        AppLabel.appearance().configurableTextColor = theme.settings.labelColor

        AppBackgroundButton.appearance().backgroundColor = theme.settings.secondaryBackgroundColor

        AppChatTextView.appearance().backgroundColor = theme.settings.textFieldBackgroundColor

        application.windows.reload()
    }

    func applyTheme(_ theme: AppTheme) {
        self.theme = theme
    }
}

extension ThemeManager: ThemesPickerDelegate {
    func changeTheme(_ theme: AppTheme) {
        self.theme = theme
    }
}
