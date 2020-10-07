import UIKit

class ThemesViewController: UIViewController {

    lazy var classicButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Classic"), for: .normal)
        button.layer.cornerRadius = 15
        button.imageView?.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        
        button.addTarget(self, action: #selector(selectClassicTheme), for: .touchUpInside)
        return button
    }()
    lazy var dayButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Day"), for: .normal)
        button.layer.cornerRadius = 15
        button.imageView?.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        
        button.addTarget(self, action: #selector(selectDayTheme), for: .touchUpInside)
        return button
    }()	
    lazy var nightButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Night"), for: .normal)
        button.layer.cornerRadius = 15
        button.imageView?.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        
        button.addTarget(self, action: #selector(selectNightTheme), for: .touchUpInside)
        return button
    }()
    
    lazy var classicLabel: AppLabel = {
        let label = AppLabel()
        label.text = "Classic"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectClassicTheme)))
        
        return label
    }()
    lazy var dayLabel: AppLabel = {
        let label = AppLabel()
        label.text = "Day"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectDayTheme)))
        return label
    }()
    lazy var nightLabel: AppLabel = {
        let label = AppLabel()
        label.text = "Night"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectNightTheme)))
        return label
    }()
    
    var currentTheme: AppTheme?{
        didSet{
            guard let curTheme = currentTheme else { return }
            switch curTheme{
            case .classic:
                configButtons(classicButton)
            case .day:
                configButtons(dayButton)
            case .night:
                configButtons(nightButton)
            }
        }
    }
    
    var changeThemeClosure: ((_ theme: AppTheme) -> Void)?
    
    var delegate: ThemesPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        self.view = AppThemesView()
        
        setupNavTitle()
        setupThemesElements()
    }
    
    // MARK: - Private functions
    
    private func setupNavTitle(){
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Settings"
        self.navigationItem.backBarButtonItem?.title = "Chat"
    }
    
    private func setupThemesElements(){
        self.view.addSubview(classicButton)
        self.view.addSubview(dayButton)
        self.view.addSubview(nightButton)
        self.view.addSubview(classicLabel)
        self.view.addSubview(dayLabel)
        self.view.addSubview(nightLabel)
        
        classicButton.translatesAutoresizingMaskIntoConstraints = false
        dayButton.translatesAutoresizingMaskIntoConstraints = false
        nightButton.translatesAutoresizingMaskIntoConstraints = false
        classicLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        nightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupSizes(for: classicButton)
        self.setupSizes(for: dayButton)
        self.setupSizes(for: nightButton)
        
        alignThemeElements(button: classicButton, label: classicLabel)
        alignThemeElements(button: dayButton, label: dayLabel)
        alignThemeElements(button: nightButton, label: nightLabel)
        
        NSLayoutConstraint.activate([
            classicButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dayButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nightButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            classicLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dayLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nightLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            classicButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 160),
            
            dayButton.topAnchor.constraint(equalTo: classicButton.bottomAnchor, constant: 80),
            
            nightButton.topAnchor.constraint(equalTo: dayButton.bottomAnchor, constant: 80),
        ])
    }
    
    private func setupSizes(for button: UIButton){
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 300),
            button.heightAnchor.constraint(equalToConstant: 57),
        ])
    }
    
    private func alignThemeElements(button: UIButton, label: UILabel){
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 25)])
    }
    
    @objc private func selectClassicTheme(sender: AnyObject){
        if let button = sender as? UIButton{
            configButtons(button)
        }
        else{
            configButtons(classicButton)
        }
        
        currentTheme = .classic
        delegate?.changeTheme(.classic)
        if let changeTheme = changeThemeClosure{
            changeTheme(.classic)
        }
    }
    @objc private func selectDayTheme(sender: AnyObject){
       if let button = sender as? UIButton{
            configButtons(button)
        }
        else{
            configButtons(dayButton)
        }
        
        currentTheme = .day
        delegate?.changeTheme(.day)
        if let changeTheme = changeThemeClosure{
            changeTheme(.day)
        }
    }
    @objc private func selectNightTheme(sender: AnyObject){
        if let button = sender as? UIButton{
            configButtons(button)
        }
        else{
            configButtons(nightButton)
        }
        
        currentTheme = .night
        delegate?.changeTheme(.night)
        if let changeTheme = changeThemeClosure{
            changeTheme(.night)
        }
    }
    @objc private func configButtons(_ sender: UIButton){
        classicButton.isSelected = false
        dayButton.isSelected = false
        nightButton.isSelected = false
        
        classicButton.layer.borderColor = UIColor.clear.cgColor
        dayButton.layer.borderColor = UIColor.clear.cgColor
        nightButton.layer.borderColor = UIColor.clear.cgColor
        
        sender.isSelected = true
        sender.layer.borderColor = UIColor.AppColors.borderSelectedThemeColor.cgColor
    }
    
    deinit {
        Logger.app.logMessage("Deinit themes", logLevel: .Info)
    }
}
