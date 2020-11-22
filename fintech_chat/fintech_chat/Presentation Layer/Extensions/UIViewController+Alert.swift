import UIKit

extension UIViewController {
    /// Показать сообщение на стилизованном alertController
    func presentMessage(_ message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.applyTheme()

        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        if presentedViewController == nil {
            present(alertController, animated: true)
        } else {
            dismiss(animated: true) {
                self.present(alertController, animated: true)
            }
        }
    }
}
