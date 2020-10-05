import UIKit

struct DayTheme: Theme{
    var backgroundColor: UIColor = .white
    var secondaryBackgroundColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1)
    let separatorColor: UIColor = .lightGray
    
    var inputMessageBackgroundColor: UIColor = UIColor(red: 67/255, green: 137/255, blue: 249/255, alpha: 1)
    
    var outputMessageBackgroundColor: UIColor = UIColor(red: 234/255, green: 235/255, blue: 237/255, alpha: 1)
    
    var labelColor: UIColor = .black
    
    var barStyle: UIBarStyle = .default
}
