import UIKit

class ThemesViewController: LoggedViewController {

    // MARK: - Public properties
    
    var changeThemeClosure: ((_ theme: AppTheme) -> Void)?

    weak var delegate: ThemesPickerDelegate?
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        let themeView = ThemeView()
        themeView.delegate = self
        view = themeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private functions

    private func setupUI() {
        setupNavTitle()
    }
    
    private func setupNavTitle() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Settings"
        self.navigationItem.backBarButtonItem?.title = "Chat"
    }
}

extension ThemesViewController: ThemeChangeDelegate {
    func select(theme: AppTheme) {
        delegate?.changeTheme(theme)
        changeThemeClosure?(theme)
    }
}
