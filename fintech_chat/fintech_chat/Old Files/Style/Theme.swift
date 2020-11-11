import UIKit

protocol Theme {
    var backgroundColor: UIColor { get }
    var secondaryBackgroundColor: UIColor {get}
    var textWrapperBackgroundColor: UIColor {get}
    var separatorColor: UIColor { get }
    var textFieldBackgroundColor: UIColor { get }

    var inputMessageBackgroundColor: UIColor { get }
    var outputMessageBackgroundColor: UIColor { get }

    var inputMessageTextColor: UIColor { get }
    var outputMessageTextColor: UIColor { get }

    var labelColor: UIColor { get }

    var indicatorStyle: UIScrollView.IndicatorStyle { get }
}

enum AppTheme: Int, CaseIterable {
    case classic
    case day
    case night
    var settings: Theme {
        switch self {
        case .classic:
            return ClassicTheme()
        case .day:
            return DayTheme()
        case .night:
            return NightTheme()
        }
    }
    var name: String {
        switch self {
        case .classic:
            return "Classic"
        case .day:
            return "Day"
        case .night:
            return "Night"
        }
    }
    var isSelected: Bool {
        return ThemeManager.shared.theme == self
    }
}

protocol ThemesPickerDelegate: class {
    func changeTheme(_ theme: AppTheme)
}
