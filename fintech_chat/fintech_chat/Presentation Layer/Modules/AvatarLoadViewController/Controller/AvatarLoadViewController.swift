import UIKit

protocol AvatarSelectDelegate: class {
    func setupImage(image: UIImage)
}

class AvatarLoadViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: AvatarSelectDelegate?
    
    // MARK: - Dependencies
    
    private lazy var collectionViewDelegate = AvatarLoadDelegate(padding: padding,
                                                                 viewController: self,
                                                                 delegate: self.delegate)
    private let imageManager: IImageManager
    
    // MARK: - Private properties
    
    private let titleVC = "Load avatar"
    private let cellId = "AvatarCell"
    private let padding: CGFloat = 8
    
    private(set) var avatars = [AvatarDisplayModel]()

    // MARK: - UI
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeVC))
        return button
    }()
    
    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = collectionViewDelegate
        collectionView.register(AvatarCollectionVIewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(imageManager: IImageManager) {
        self.imageManager = imageManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        fetchAvatars()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        navigationItem.title = titleVC
        navigationItem.leftBarButtonItem = closeButton
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func fetchAvatars() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        imageManager.loadImages { [weak self] (result) in
            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
            }
            
            switch result {
            case .success(let data):
                self?.avatars = data.compactMap { AvatarDisplayModel(apiModel: $0) }
                DispatchQueue.main.async {[weak self] in
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                self?.presentMessage("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - UICollectionViewDataSource

extension AvatarLoadViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                            for: indexPath) as? AvatarCollectionVIewCell else { return UICollectionViewCell()}

        var avatar = self.avatars[indexPath.row]
        
        if avatar.avatar == nil {
            imageManager.loadConcreteImage(url: avatar.imageUrl) { (model) in
                guard let model = model else { return }
                DispatchQueue.main.async {[weak self] in
                    avatar.avatar = model.image
                    cell.configure(with: avatar)
                    self?.avatars[indexPath.row].avatar = model.image
                }
            }
        }
        
        cell.configure(with: avatar)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
}
