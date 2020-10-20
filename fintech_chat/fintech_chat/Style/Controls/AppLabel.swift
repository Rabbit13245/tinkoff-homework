import UIKit

class AppLabel: UILabel{
    
    @objc dynamic var configurableTextColor: UIColor{
        get {
            return textColor
        }
        set{
            textColor = newValue
        }
    }
}
