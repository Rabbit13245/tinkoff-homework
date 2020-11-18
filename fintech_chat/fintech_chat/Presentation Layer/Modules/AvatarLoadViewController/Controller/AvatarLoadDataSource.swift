import UIKit

class AvatarLoadDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Private properties
    
    private let cellId: String
    
    // MARK: - Initializers
    
    init(cellId: String) {
        self.cellId = cellId
    }
    
    // MARK: - DataSource methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                            for: indexPath) as? AvatarCollectionVIewCell else { return UICollectionViewCell()}

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
}
