import UIKit

class ConversationsListViewController: UITableViewController {
    
    lazy var dataGenerator: FakeDataGenerator = {
        let fakeDataGenerator = FakeDataGenerator()
        return fakeDataGenerator
    }()
    
    lazy var mainStoryboard: UIStoryboard? = {
        let storyboard = self.navigationController?.storyboard
        return storyboard
    }()
    
    lazy var settingsBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        return barButton
    }()
    
    lazy var profileBarButton: UIBarButtonItem = {
        let customView = Helper.app.generateDefaultAvatar(name: "Dmitry Zaytcev", width: 34)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        view.addSubview(customView)
        
        let barButtom = UIBarButtonItem(customView: view)
        barButtom.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButtonPressed)))
        return barButtom
    }()
    
    var conversations : [[ConversationCellModel]]?
    
    let chatName = "Tinkoff Chat"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationTableViewCell.self))
        
        conversations = dataGenerator.getFriends()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = chatName
        settingsBarButton.tintColor = ThemeManager.shared.theme.settings.labelColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return conversations?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?[section].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationTableViewCell.self), for: indexPath) as? ConversationTableViewCell else {return UITableViewCell()}
                
        let cellData = conversations?[indexPath.section][indexPath.row] ?? dataGenerator.getDefaulModel()
        
        cell.configure(with: cellData)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ConversationViewController()
        
        controller.friendName = conversations?[indexPath.section][indexPath.row].name ?? dataGenerator.getDefaulModel().name
        controller.friendAvatar = conversations?[indexPath.section][indexPath.row].avatar ?? dataGenerator.getDefaulModel().avatar
        
        controller.messages = dataGenerator.getMessages()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = AppLabel()
        label.font = UIFont.systemFont(ofSize: 28)
        switch section {
        case 0:
            label.text =  "Online"
        case 1:
            label.text =  "History"
        default:
            label.text =  ""
        }
        return label
    }
    
    // MARK: - Private functions
    
    private func setupUI(){
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = chatName
        
        self.navigationItem.leftBarButtonItem = settingsBarButton
        self.navigationItem.rightBarButtonItem = profileBarButton
        
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.placeholder = "Search friends"
//        searchController.obscuresBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        self.navigationItem.searchController = searchController
    }
    
    @objc private func profileButtonPressed(){
        guard let storyboard = storyboard else {return}
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @objc private func settingsButtonPressed(){
        let themesVC = ThemesViewController()
        
        themesVC.currentTheme = ThemeManager.shared.theme
        themesVC.delegate = ThemeManager.shared
        //themesVC.changeThemeClosure = ThemeManager.shared.applyTheme
        
        self.navigationController?.pushViewController(themesVC, animated: true)
    }
}
