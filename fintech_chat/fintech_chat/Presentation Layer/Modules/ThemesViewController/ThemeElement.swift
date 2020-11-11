import UIKit

protocol ThemeChangeDelegate: class {
    func select(theme: AppTheme)
}

class ThemeElement: UIView {
    
    // MARK: - Public properties
    
    var theme: AppTheme?
    weak var themeElementDelegate: ThemeChangeDelegate?
    
    // MARK: - Private properties
    private let buttonHeight: CGFloat = 60
    private let padding: CGFloat = 15
    
    // MARK: - UI
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: buttonHeight + padding + label.intrinsicContentSize.height)
    }
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var label: AppLabel = {
        let label = AppLabel()
        label.text = "Classic"
        label.isUserInteractionEnabled = true

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(button)
        addSubview(label)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 300),
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            button.topAnchor.constraint(equalTo: topAnchor),
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: padding),
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Public methods
    
    func activeTheme() {
        button.isSelected = true
        label.layer.borderColor = UIColor.AppColors.borderSelectedThemeColor.cgColor
    }
    
    func deactiveTheme() {
        button.isSelected = false
        label.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Actions
    
    @objc private func selectTheme() {
        guard let theme = self.theme else { return }
        themeElementDelegate?.select(theme: theme)
    }
}

extension ThemeElement: ConfigurableView {
    typealias ConfigurationModel = AppTheme
    
    func configure(with model: AppTheme) {
        theme = model
        
        button.setImage(UIImage(named: model.name), for: .normal)
        button.imageView?.layer.cornerRadius = 15
        label.text = model.name
    }
}
