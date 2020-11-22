import UIKit

protocol ThemeChangeDelegate: class {
    func select(theme: AppTheme)
}

class ThemeElement: UIView {
    
    // MARK: - Public properties
    
    var theme: AppTheme?
    weak var delegate: ThemeChangeDelegate?
    
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
        
        button.addTarget(self, action: #selector(selectTheme), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var label: AppLabel = {
        let label = AppLabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectTheme)))
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
        ])
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(button)
        addSubview(label)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            button.topAnchor.constraint(equalTo: topAnchor),
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: padding),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func selectTheme() {
        guard let theme = self.theme else { return }
        delegate?.select(theme: theme)
    }
}

extension ThemeElement: ConfigurableView {
    typealias ConfigurationModel = AppTheme
    
    func configure(with model: AppTheme) {
        theme = model
        
        button.setImage(UIImage(named: model.name), for: .normal)
        button.imageView?.layer.cornerRadius = 15
        label.text = model.name
        
        if model.isSelected {
            button.isSelected = true
            button.layer.borderColor = UIColor.red.cgColor
        } else {
            button.isSelected = false
            button.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
