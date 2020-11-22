import UIKit

protocol IThemeManager: ThemesPickerDelegate {
    
    /// Применить выбранную тему
    func applyTheme(_ theme: AppTheme)
}
