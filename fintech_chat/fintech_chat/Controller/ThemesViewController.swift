import UIKit

class ThemesViewController: UIViewController {

    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtomItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        
        return barButtomItem
    }()
    
    lazy var classicButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Classic theme select", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(self, action: #selector(selectClassicTheme), for: .touchUpInside)
        return button
    }()
    lazy var dayButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Day theme select", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(self, action: #selector(selectDayTheme), for: .touchUpInside)
        return button
    }()	
    lazy var nightButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Night theme select", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(selectNightTheme), for: .touchUpInside)
        return button
    }()
    
    lazy var classicLabel: UILabel = {
        let label = UILabel()
        label.text = "Classic"
        label.textColor = .white
        return label
    }()
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Day"
        label.textColor = .white
        return label
    }()
    lazy var nightLabel: UILabel = {
        let label = UILabel()
        label.text = "Night"
        label.textColor = .white
        return label
    }()
    
    var delegate: ThemeChangeDelegate?
    
    var currentTheme: AppTheme?
    
    var someClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        self.view = AppView()
        
        setupNavTitle()
        setupThemesElements()
    }
    
    // MARK: - Private functions
    private func setupNavTitle(){
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Settings"
        self.navigationItem.backBarButtonItem?.title = "Chat"
        
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
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
    
    @objc private func cancelButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectClassicTheme(sender: UIButton){
        configButtons(sender)
        //self.view.backgroundColor = UIColor.AppColors.themeClassicBackgroundColor
        
        currentTheme = .classic
        delegate?.changeTheme(.classic)
    }
    @objc private func selectDayTheme(sender: UIButton){
        configButtons(sender)
        //self.view.backgroundColor = UIColor.AppColors.themeDayBackgroundColor
        
        currentTheme = .day
        delegate?.changeTheme(.day)
    }
    @objc private func selectNightTheme(sender: UIButton){
        configButtons(sender)
        //self.view.backgroundColor = UIColor.AppColors.themeNightBackgroundColor
        
        currentTheme = .night
        delegate?.changeTheme(.night)
    }
    @objc private func configButtons(_ sender: UIButton){
        classicButton.isSelected = false
        dayButton.isSelected = false
        nightButton.isSelected = false
        
        classicButton.layer.borderColor = UIColor.clear.cgColor
        dayButton.layer.borderColor = UIColor.clear.cgColor
        nightButton.layer.borderColor = UIColor.clear.cgColor
        
        sender.isSelected = true
        sender.layer.borderColor = UIColor.red.cgColor
    }
    
    deinit {
        Logger.app.logMessage("Deinit themes", logLevel: .Info)
    }
}
