import UIKit

extension UIAlertController{
    func setBackground(color: UIColor){
        guard let backView = self.view.subviews.first,
            let groupView = backView.subviews.first,
            let contentView = groupView.subviews.first
            else { return }
        contentView.backgroundColor = color
    }
    
    func setTitle(color: UIColor){
        guard let title = self.title else {return}
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttributes([
        NSAttributedString.Key.foregroundColor: color],
                                       range: NSMakeRange(0, title.utf8.count))
        self.setValue(attributedString, forKey: "attributedTitle")
    }
    
    func setMessage(color: UIColor){
        guard let message = self.message else {return}
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttributes([
            NSAttributedString.Key.foregroundColor: color
        ], range: NSMakeRange(0, message.utf8.count))
        self.setValue(attributedString, forKey: "attributedMessage")
    }
    
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
