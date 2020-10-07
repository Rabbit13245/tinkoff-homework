import UIKit

struct ClassicTheme: Theme{
    var backgroundColor: UIColor = .white
    var secondaryBackgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    var textWrapperBackgroundColor: UIColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    var separatorColor: UIColor = .lightGray
    var textFieldBackgroundColor: UIColor = .white
    
    var inputMessageBackgroundColor: UIColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
    var outputMessageBackgroundColor: UIColor = UIColor(red: 220/255, green: 247/255, blue: 197/255, alpha: 1)
    
    var inputMessageTextColor: UIColor = .black
    var outputMessageTextColor: UIColor = .black
    
    var labelColor: UIColor = .black
    
    var indicatorStyle: UIScrollView.IndicatorStyle = .black
}
