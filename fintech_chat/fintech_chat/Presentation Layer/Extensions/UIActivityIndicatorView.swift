import UIKit

extension UIActivityIndicatorView {
    func startLoading() {
        self.isHidden = false
        self.startAnimating()
    }
    func stopLoading() {
        self.isHidden = true
        self.startAnimating()
    }
}
