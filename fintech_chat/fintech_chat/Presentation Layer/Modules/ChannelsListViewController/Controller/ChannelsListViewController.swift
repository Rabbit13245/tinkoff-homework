import UIKit

import Firebase
import CoreData

class ChannelsListViewController: UIViewController {

    // MARK: - Private properties
    
    private var userName = ""
    private let chatName = "Channels"
    
    // MARK: - FRC
    
    private lazy var fetchedResultController: NSFetchedResultsController<ChannelDb> = {
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        
        request.sortDescriptors = [.init(key: "lastActivity", ascending: false),
                                   .init(key: "name", ascending: true)]
        request.fetchBatchSize = 30
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        frc.delegate = self
        
        return frc
    }()
    
    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    private var createChannelAction: UIAlertAction?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.isHidden = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        return activityIndicator
    }()

    private lazy var settingsBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        return barButton
    }()

    private lazy var profileBarButton: UIBarButtonItem = {
        // Для ios 12 получается только так
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.AppColors.yellowLogo
        button.setTitleColor(UIColor.AppColors.initialsColor, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        button.layer.cornerRadius = button.frame.height / 2
        
        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButtonPressed)))
        
        guard let manager = dataManagerFactory?.createDataManager(.GCD) else { return barButton }

        manager.loadName {(name, error) in
            if !error {
                self.userName = name
            }
            button.setTitle(Helper.app.getInitials(from: self.userName), for: .normal)
        }
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
    
    // MARK: - Dependencies
    
    private var presentationAssembly: IPresentationAssembly?
    private var channelManager: IChannelManager?
    private var dataManagerFactory: IDataManagerFactory?
    
    // MARK: - Setup dependencies
    
    func setupDependencies(channelManager: IChannelManager,
                           dataManagerFactory: IDataManagerFactory,
                           presentationAssembly: IPresentationAssembly) {
        self.channelManager = channelManager
        self.dataManagerFactory = dataManagerFactory
        self.presentationAssembly = presentationAssembly
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTable()
        
        getCacheChannels()
        channelManager?.subscribeChannels(completion: { [weak self] (error) in
            guard error != nil else { return }
            DispatchQueue.main.async {
                self?.presentMessage("Error subscribing channels")
            }
        })
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
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(
            nibName: String(describing: ConversationTableViewCell.self),
            bundle: nil),
                           forCellReuseIdentifier: String(describing: ConversationTableViewCell.self))

        self.tableView.tableFooterView = AppView()
    }

    private func getCacheChannels() {
        do {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            try fetchedResultController.performFetch()
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        } catch {
            Logger.app.logMessage("FRC channels error: \(error.localizedDescription)", logLevel: .error)
        }
    }
}

// MARK: - UISetup

extension ChannelsListViewController {
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = chatName

        self.navigationItem.leftBarButtonItem = self.settingsBarButton
        self.navigationItem.rightBarButtonItems = [self.profileBarButton, self.addChannelBarButton]

        guard let manager = dataManagerFactory?.createDataManager(.GCD) else { return }
        manager.loadImage { (image, error) in
            if !error {
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

    private func setupUI() {
        setupNavigationController()

        self.view.addSubview(self.noChannelsLabel)
        self.view.addSubview(self.activityIndicator)

        NSLayoutConstraint.activate([
            self.noChannelsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.noChannelsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

// MARK: - Actions
extension ChannelsListViewController {
    @objc private func profileButtonPressed() {
        guard let profileVC = presentationAssembly?.profileViewController() else { return }
        self.present(profileVC, animated: true, completion: nil)
    }

    @objc private func settingsButtonPressed() {
        guard let themesVC = presentationAssembly?.themesViewController() else { return }
        self.navigationController?.pushViewController(themesVC, animated: true)
    }

    @objc private func addChannelButtonPressed() {
        let alertController = UIAlertController(title: "Create channel", message: nil, preferredStyle: .alert)
        alertController.applyTheme()
        alertController.addTextField { [weak self] textField in
            textField.applyTheme()
            textField.addTarget(self, action: #selector(self?.textFieldDidChange(_:)), for: .editingChanged)
        }

        let createAction = UIAlertAction(title: "Create", style: .default) { [weak alertController, weak self] _ in
        guard let safeAC = alertController,
            let safeTF = safeAC.textFields?.first,
            let channelName = safeTF.text,
            channelName.count > 0 else { return }

            self?.addChannelBarButton.isEnabled = false
            
            self?.channelManager?.createChannel(with: channelName, completion: { [weak self] (error) in
                self?.addChannelBarButton.isEnabled = true
                guard error != nil else {return}
                
                DispatchQueue.main.async {
                    self?.presentMessage("Error creating channel")
                }
            })
        }

        createAction.isEnabled = false
        self.createChannelAction = createAction

        alertController.addAction(createAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.createChannelAction?.isEnabled = !textField.text.isBlank
    }
}

// MARK: - Table view data source
extension ChannelsListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ConversationTableViewCell.self),
            for: indexPath) as? ConversationTableViewCell else {return UITableViewCell()}

        //let cellData = self.channels[indexPath.row]
        let channelDb = fetchedResultController.object(at: indexPath)
        let cellData = ChannelCellModel(channelDb)
        
        cell.configure(with: cellData)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channelForRemove = fetchedResultController.object(at: indexPath)
            channelManager?.removeChannel(channelForRemove.identifier) { [weak self] (error) in
                guard error != nil else { return }
                DispatchQueue.main.async {
                    self?.presentMessage("Error removing channel")
                }
            }
        }
    }
}

// MARK: - Table view delegate
extension ChannelsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let channelDb = fetchedResultController.object(at: indexPath)
        let channelCellModel = ChannelCellModel(channelDb)
        
        guard let channelVC = presentationAssembly?.channelViewController(channel: channelCellModel) else { return }

        self.navigationController?.pushViewController(channelVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ChannelsListViewController: NSFetchedResultsControllerDelegate {
    /// Начало изменения
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    /// Изменение объекта
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                Logger.app.logMessage("ChannelList Insert \(newIndexPath)", logLevel: .debug)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                Logger.app.logMessage("ChannelList Delete \(indexPath)", logLevel: .debug)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let newIndexPath = newIndexPath,
                let oldIndexPath = indexPath {
                Logger.app.logMessage("ChannelList Move", logLevel: .debug)
                tableView.deleteRows(at: [oldIndexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                Logger.app.logMessage("ChannelList Update \(indexPath)", logLevel: .debug)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    /// Конец изменения
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
