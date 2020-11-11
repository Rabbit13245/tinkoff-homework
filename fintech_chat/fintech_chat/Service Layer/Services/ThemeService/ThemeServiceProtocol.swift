import UIKit

protocol IThemeManager {
    /// Применить тему для приложения
    func apply(for application: UIApplication)
    
    /// Применить выбранную тему
    func applyTheme(_ theme: AppTheme)
}
