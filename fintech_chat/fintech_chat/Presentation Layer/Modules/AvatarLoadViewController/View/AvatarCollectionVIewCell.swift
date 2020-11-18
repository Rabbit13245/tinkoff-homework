import UIKit

class AvatarCollectionVIewCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "avatar_placeholder"))
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(imageView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension AvatarCollectionVIewCell: ConfigurableView {
    typealias ConfigurationModel = AvatarDisplayModel
    
    func configure(with model: AvatarDisplayModel) {
        imageView.image = #imageLiteral(resourceName: "avatar_placeholder")
        if let avatar = model.avatar {
            imageView.image = avatar
        }
    }
}
