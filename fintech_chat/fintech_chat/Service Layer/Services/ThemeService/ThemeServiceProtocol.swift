import UIKit

protocol ThemeManagerProtocol {
    /// Применить тему для приложения
    func apply(for application: UIApplication)
    
    /// Применить выбранную тему
    func applyTheme(_ theme: AppTheme)
}
