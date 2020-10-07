import UIKit

protocol Theme {
    var backgroundColor: UIColor { get }
    var secondaryBackgroundColor: UIColor {get}
    var textWrapperBackgroundColor: UIColor {get}
    var separatorColor: UIColor { get }
    var textFieldBackgroundColor: UIColor { get }
    
    var inputMessageBackgroundColor: UIColor { get }
    var outputMessageBackgroundColor: UIColor { get }
    
    var labelColor: UIColor { get }
    
    var indicatorStyle: UIScrollView.IndicatorStyle { get }
}

enum AppTheme: Int{
    case classic
    case day
    case night
    var settings: Theme{
        switch self{
        case .classic:
            return ClassicTheme()
        case .day:
            return DayTheme()
        case .night:
            return NightTheme()
        }
    }
}

protocol ThemesPickerDelegate{
    func changeTheme(_ theme: AppTheme)
}
