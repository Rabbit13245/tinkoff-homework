import UIKit

struct DayTheme: Theme {
    var backgroundColor: UIColor = .white
    var secondaryBackgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
    var textWrapperBackgroundColor: UIColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
    var separatorColor: UIColor = .lightGray
    var textFieldBackgroundColor: UIColor = .white

    var inputMessageBackgroundColor: UIColor = UIColor(red: 234 / 255, green: 235 / 255, blue: 237 / 255, alpha: 1)
    var outputMessageBackgroundColor: UIColor = UIColor(red: 67 / 255, green: 137 / 255, blue: 249 / 255, alpha: 1)

    var inputMessageTextColor: UIColor = .black
    var outputMessageTextColor: UIColor = .white

    var labelColor: UIColor = .black

    var indicatorStyle: UIScrollView.IndicatorStyle = .black
}
