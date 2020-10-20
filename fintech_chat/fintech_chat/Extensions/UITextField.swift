import UIKit

extension UITextField{
    func applyTheme() {
        superview?.backgroundColor = ThemeManager.shared.theme.settings.inputMessageBackgroundColor
    }
}
