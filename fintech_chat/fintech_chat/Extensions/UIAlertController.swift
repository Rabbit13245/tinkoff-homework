import UIKit

extension UIAlertController{
    func applyTheme(){
        guard let backView = self.view.subviews.first,
            let groupView = backView.subviews.first,
            let contentView = groupView.subviews.first
            else { return }
        contentView.backgroundColor = ThemeManager.shared.theme.settings.secondaryBackgroundColor
        
        guard let title = self.title else {return}
        let attributedStringTitle = NSMutableAttributedString(string: title)
        attributedStringTitle.addAttributes([
        NSAttributedString.Key.foregroundColor: ThemeManager.shared.theme.settings.labelColor], range: NSMakeRange(0, title.utf8.count))
        self.setValue(attributedStringTitle, forKey: "attributedTitle")
        
        guard let message = self.message else {return}
        let attributedStringMessage = NSMutableAttributedString(string: message)
        attributedStringMessage.addAttributes([
            NSAttributedString.Key.foregroundColor: ThemeManager.shared.theme.settings.labelColor], range: NSMakeRange(0, message.utf8.count))
        self.setValue(attributedStringMessage, forKey: "attributedMessage")
    }
}
