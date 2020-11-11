import UIKit

class ThemesViewController: UIViewController {

    

    var currentTheme: AppTheme?
    //{
//        didSet {
//            guard let curTheme = currentTheme else { return }
//            switch curTheme {
//            case .classic:
//                configButtons(classicButton)
//            case .day:
//                configButtons(dayButton)
//            case .night:
//                configButtons(nightButton)
//            }
//        }
    //}

    var changeThemeClosure: ((_ theme: AppTheme) -> Void)?

    weak var delegate: ThemesPickerDelegate?

    override func loadView() {
        view = ThemeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
    
        setupNavTitle()
        setupThemesElements()
    }

    // MARK: - Private functions

    private func setupNavTitle() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Settings"
        self.navigationItem.backBarButtonItem?.title = "Chat"
    }

    private func setupThemesElements() {
        
    }

    @objc private func selectClassicTheme(sender: AnyObject) {
//        if let button = sender as? UIButton {
//            configButtons(button)
//        } else {
//            configButtons(classicButton)
//        }

        currentTheme = .classic
        delegate?.changeTheme(.classic)
        if let changeTheme = changeThemeClosure {
            changeTheme(.classic)
        }
    }
    @objc private func selectDayTheme(sender: AnyObject) {
//       if let button = sender as? UIButton {
//            configButtons(button)
//        } else {
//            configButtons(dayButton)
//        }

        currentTheme = .day
        delegate?.changeTheme(.day)
        if let changeTheme = changeThemeClosure {
            changeTheme(.day)
        }
    }
    @objc private func selectNightTheme(sender: AnyObject) {
//        if let button = sender as? UIButton {
//            configButtons(button)
//        } else {
//            configButtons(nightButton)
//        }

        currentTheme = .night
        delegate?.changeTheme(.night)
        if let changeTheme = changeThemeClosure {
            changeTheme(.night)
        }
    }
}
