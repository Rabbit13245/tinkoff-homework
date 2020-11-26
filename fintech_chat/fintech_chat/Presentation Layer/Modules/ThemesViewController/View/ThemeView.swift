import UIKit

class ThemeView: AppThemesView {

    weak var delegate: ThemeChangeDelegate?
    
    // MARK: - UI
    
    private lazy var themeElements: [ThemeElement] = {
        var elements = [ThemeElement]()
        AppTheme.allCases.forEach {
            let theme = ThemeElement()
            theme.configure(with: $0)
            theme.delegate = self
            
            elements.append(theme)
        }
        
        return elements
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
        let sv = UIStackView(arrangedSubviews: themeElements)
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false

        addSubview(sv)
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            sv.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            sv.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        setupLayout()
    }
    
    private func setupLayout() {
        
    }
}

extension ThemeView: ThemeChangeDelegate {
    func select(theme: AppTheme) {
        self.delegate?.select(theme: theme)
        
        for (index, element) in AppTheme.allCases.enumerated() {
            themeElements[index].configure(with: element)
        }
    }
}
