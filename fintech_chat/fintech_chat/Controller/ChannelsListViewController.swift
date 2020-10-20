import UIKit
import Firebase


class ChannelsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var userName = "Dmitry Zaytcev"
    
    private let chatName = "Tinkoff Chat"
    
    private var channels = [Channel](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var createChannelAction: UIAlertAction?
    
    private lazy var dataManagerFactory: DataManagerFactory = {
        let dataManagerFactory = DataManagerFactory()
        return dataManagerFactory
    }()
    
    private lazy var mainStoryboard: UIStoryboard? = {
        let storyboard = self.navigationController?.storyboard
        return storyboard
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    private lazy var settingsBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        return barButton
    }()
    
    private lazy var profileBarButton: UIBarButtonItem = {
        // let customView = Helper.app.generateDefaultAvatar(name: "Dmitry Zaytcev", width: 34)
        // let view = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        // view.addSubview(customView)
        // let barButtom = UIBarButtonItem(customView: view)
        
        // Для ios 12 получается только так
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.AppColors.yellowLogo;
        button.setTitleColor(UIColor.AppColors.initialsColor, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        button.layer.cornerRadius = button.frame.height / 2
        
        let manager = dataManagerFactory.createDataManager(.GCD)
        
        manager.loadName{(name, error) in
            if (!error){
                self.userName = name
            }
            button.setTitle(Helper.app.getInitials(from: self.userName), for: .normal)
        }
        
        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButtonPressed)))
        return barButton
    }()
    
    private lazy var addChannelBarButton: AppBarButtonItem = {
        let barButtonItem = AppBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannelButtonPressed))
        return barButtonItem
    }()
    
    private lazy var noChannelsLabel: AppLabel = {
        let label = AppLabel()
        label.text = "No channels!"
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTable()
        getChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingsBarButton.tintColor = ThemeManager.shared.theme.settings.labelColor
        addChannelBarButton.tintColor = ThemeManager.shared.theme.settings.labelColor
        
        self.navigationItem.title = chatName
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    // MARK: - Private functions
    private func setupTable(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationTableViewCell.self))
        
        self.tableView.tableFooterView = AppView()
    }
    
    private func getChannels(){
        self.activityIndicator.startLoading()

        DbManager.shared.getAllChannels { [weak self] (result) in
            switch result{
            case .success(let channels):
                self?.activityIndicator.stopLoading()
                guard !channels.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noChannelsLabel.isHidden = false
                    return
                }
                self?.tableView.isHidden = false
                self?.noChannelsLabel.isHidden = true
                self?.channels = channels
                
            case .failure(_):
                self?.tableView.isHidden = true
                self?.noChannelsLabel.isHidden = false
                self?.activityIndicator.stopLoading()
            }
        }
    }
}

// MARK:- UISetup
extension ChannelsListViewController{
    
    private func setupNavigationController(){
        let manager = dataManagerFactory.createDataManager(.GCD)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = chatName
    
        self.navigationItem.leftBarButtonItem = self.settingsBarButton
        self.navigationItem.rightBarButtonItems = [self.profileBarButton, self.addChannelBarButton]
        
        manager.loadImage { (image, error) in
            if(!error){
                let customView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
                customView.layer.cornerRadius = customView.frame.height / 2
                let uiImageView = UIImageView(image: image)
                uiImageView.layer.cornerRadius = customView.frame.height / 2
                uiImageView.frame = customView.frame
                uiImageView.contentMode = .scaleAspectFill
                uiImageView.clipsToBounds = true
                customView.addSubview(uiImageView)
                let barButtonItem = UIBarButtonItem(customView: customView)
                barButtonItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileButtonPressed)))
                self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: customView), self.addChannelBarButton]
            }
        }
    }
    
    private func setupUI(){
        setupNavigationController()
    
        self.view.addSubview(self.noChannelsLabel)
        self.view.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.noChannelsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.noChannelsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        
        
        //        let searchController = UISearchController(searchResultsController: nil)
        //        searchController.searchBar.placeholder = "Search friends"
        //        searchController.obscuresBackgroundDuringPresentation = false
        //        definesPresentationContext = true
        //        self.navigationItem.searchController = searchController
    }
}

// MARK: - Actions
extension ChannelsListViewController{
    @objc private func profileButtonPressed(){
        guard let storyboard = storyboard else {return}
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @objc private func settingsButtonPressed(){
        let themesVC = ThemesViewController()
        
        themesVC.currentTheme = ThemeManager.shared.theme
        //themesVC.delegate = ThemeManager.shared
        themesVC.changeThemeClosure = ThemeManager.shared.applyTheme
        
        self.navigationController?.pushViewController(themesVC, animated: true)
    }
    
    @objc private func addChannelButtonPressed(){
        let alertController = UIAlertController(title: "Create channel", message: nil, preferredStyle: .alert)
        alertController.applyTheme()
        alertController.addTextField(){ [weak self] textField in
            textField.applyTheme()
            textField.addTarget(self, action: #selector(self?.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) {[weak alertController, weak self]_ in
        guard let safeAC = alertController,
            let safeTF = safeAC.textFields?.first,
            let channelName = safeTF.text,
            channelName.count > 0 else { return }
            
            self?.addChannelBarButton.isEnabled = false
            DbManager.shared.createChannel(with: channelName) { [weak self] (error) in
                self?.addChannelBarButton.isEnabled = true
                guard let _ = error else {return}
                self?.presentMessage("Error creating channel")
            }
        }
        
        createAction.isEnabled = false
        self.createChannelAction = createAction
        
        alertController.addAction(createAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.createChannelAction?.isEnabled = textField.text?.count ?? 0 > 0 ? true : false
    }
    
    private func presentMessage(_ message: String){
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.applyTheme()
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: - Table view data source
extension ChannelsListViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationTableViewCell.self), for: indexPath) as? ConversationTableViewCell else {return UITableViewCell()}
        
        let cellData = self.channels[indexPath.row]
        
        cell.configure(with: cellData)
        
        return cell
    }
}

// MARK: - Table view delegate
extension ChannelsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = ChannelViewController(channelName: channels[indexPath.row].name, channelId: channels[indexPath.row].identifier)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AppSeparator()
        let label = AppLabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.text =  "Channels"
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}