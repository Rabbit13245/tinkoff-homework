import UIKit

struct NightTheme: Theme {
    var backgroundColor: UIColor = .black
    var secondaryBackgroundColor = UIColor(red: 59 / 255, green: 59 / 255, blue: 59 / 255, alpha: 1)
    var textWrapperBackgroundColor: UIColor = .black
    var separatorColor: UIColor = .lightGray
    var textFieldBackgroundColor: UIColor = UIColor(red: 59 / 255, green: 59 / 255, blue: 59 / 255, alpha: 1)

    var inputMessageBackgroundColor: UIColor = UIColor(red: 92 / 255, green: 92 / 255, blue: 92 / 255, alpha: 1)
    var outputMessageBackgroundColor: UIColor = UIColor(red: 46 / 255, green: 46 / 255, blue: 46 / 255, alpha: 1)

    var inputMessageTextColor: UIColor = .white
    var outputMessageTextColor: UIColor = .white

    var labelColor: UIColor = .white

    var indicatorStyle: UIScrollView.IndicatorStyle = .white
}
