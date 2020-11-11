import UIKit

class ThemeView: AppThemesView {

    // MARK: - UI
    
    private lazy var themeElements: [ThemeElement] = {
        var elements = [ThemeElement]()
        AppTheme.allCases.forEach {
            let theme = ThemeElement()
            theme.configure(with: $0)
            elements.append(theme)
        }
        
        return elements
    }()
    
    private lazy var temp: ThemeElement = {
        let theme = ThemeElement()
        theme.configure(with: AppTheme.classic)
        theme.translatesAutoresizingMaskIntoConstraints = false
        return theme
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
            sv.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 10),
            sv.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)

        ])
        
        //addSubview(temp)
        
        // setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            temp.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            temp.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 10),
            temp.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
}
