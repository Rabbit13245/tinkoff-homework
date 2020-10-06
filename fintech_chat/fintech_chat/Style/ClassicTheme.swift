import UIKit

struct ClassicTheme: Theme{
    var backgroundColor: UIColor = .white
    var secondaryBackgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    let separatorColor: UIColor = .lightGray
    
    var inputMessageBackgroundColor: UIColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
    var outputMessageBackgroundColor: UIColor = UIColor(red: 220/255, green: 247/255, blue: 197/255, alpha: 1)
    
    var labelColor: UIColor = .black
}
