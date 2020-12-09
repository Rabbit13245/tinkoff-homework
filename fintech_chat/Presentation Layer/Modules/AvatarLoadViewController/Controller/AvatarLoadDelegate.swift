import UIKit

class AvatarLoadDelegate: NSObject, UICollectionViewDelegate {
    
    // MARK: - Private properties
    
    private let padding: CGFloat
    private let itemsInRow: CGFloat = 3
    private weak var viewController: AvatarLoadViewController?
    private weak var delegate: AvatarSelectDelegate?
    
    // MARK: - Initializers
    init(padding: CGFloat, viewController: AvatarLoadViewController, delegate: AvatarSelectDelegate?) {
        self.padding = padding
        self.viewController = viewController
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let avatarModel = viewController?.avatars[indexPath.row],
              let avatarImage = avatarModel.avatar else {
            viewController?.presentMessage("Cant get image")
            return
        }
        delegate?.setupImage(image: avatarImage)
        viewController?.dismiss(animated: true, completion: nil)
    }
}

extension AvatarLoadDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalPadding = (2 * padding) + (itemsInRow - 1) * padding
        let width = (collectionView.bounds.width - totalPadding) / itemsInRow

        return CGSize(width: width, height: width)
    }    
}
