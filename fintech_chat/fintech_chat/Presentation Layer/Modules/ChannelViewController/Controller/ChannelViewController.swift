import UIKit
import CoreData

class ChannelViewController: UIViewController {
    
    // MARK: - Private properties
    
    /// Канал, по которому будем выводить сообщения
    private var channel: ChannelCellModel
    private let cellIdentifier = String(describing: MessageTableViewCell.self)
    private var keyboardHeight: CGFloat = 0
    
    private lazy var tableViewDelegate = ChannelViewControllerDelegate(frc: fetchedResultController, vc: self)
    private lazy var tableViewDataSource = ChannelViewControllerDataSource(frc: fetchedResultController, vc: self)
    
    // MARK: - Dependencies
    
    private var messageManager: IMessageManager
    
    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        
        return tableView
    }()

    private lazy var messageInputView: SendMessageView = {
        let view = SendMessageView()
        view.inputTextView.delegate = self
        view.buttonSend.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var bottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: messageInputView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        return constraint
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.isHidden = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        return activityIndicator
    }()

    private lazy var noMessagesLabel: AppLabel = {
        let label = AppLabel()
        label.text = "No messages!"
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - FRC
    
    internal lazy var fetchedResultController: NSFetchedResultsController<MessageDb> = {
        let request: NSFetchRequest<MessageDb> = MessageDb.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sort]

        let predicate = NSPredicate(format: "channel.identifier == %@", self.channel.identifier)
        request.predicate = predicate
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()

    // MARK: - Initializers
    
    init(channel: ChannelCellModel, messageManager: IMessageManager) {
        self.channel = channel
        self.messageManager = messageManager
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        getCachedMessages()
        messageManager.subscribeOnChannelMessagesUpdates(channelId: self.channel.identifier) { [weak self] (error) in
            if error != nil {
                DispatchQueue.main.async {
                    self?.presentMessage("Error subscribing messages")
                }
            }
        }
//        messageManager.subscribeOnChannelMessages(channelId: self.channel.identifier, )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        unsubscribeKeyboardNotifications()
    }

    // MARK: - Private functions
    
    private func scrollTableToBottom() {
        guard let sectionNumber = fetchedResultController.sections?.count,
            sectionNumber > 0,
            let elementsNumber = fetchedResultController.sections?[sectionNumber - 1].numberOfObjects,
            elementsNumber > 0 else { return }
        
        self.tableView.scrollToRow(at: IndexPath(row: elementsNumber - 1, section: sectionNumber - 1), at: .bottom, animated: true)
    }
    
    private func getCachedMessages() {
        do {
            self.activityIndicator.startAnimating()
            try fetchedResultController.performFetch()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.tableView.reloadData()
        } catch {
            Logger.app.logMessage("FRC messages error: \(error.localizedDescription)", logLevel: .error)
        }
    }

    fileprivate func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeybord))
        view.addGestureRecognizer(tap)
    }
    
    private func setupUI() {
        self.view = AppView()

        setupView()
        setupNavTitle()
        setupTableView()
        setupInputView()
        setupActivityIndicator()

        subscribeKeyboardNotifications()
    }

    private func setupActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.noMessagesLabel)

        NSLayoutConstraint.activate([
            self.noMessagesLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.noMessagesLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        self.tableView.tableFooterView = AppView()
        self.tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80)
        ])
    }

    private func setupInputView() {
        self.view.addSubview(messageInputView)

        NSLayoutConstraint.activate([
            messageInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomConstraint,
            messageInputView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupNavTitle() {
        self.navigationItem.largeTitleDisplayMode = .never

        let label = AppLabel()
        label.text = channel.name
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center

        self.navigationItem.titleView = label
    }

    private func subscribeKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unsubscribeKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - actions
extension ChannelViewController {
    @objc func messageTextFieldDidChange(_ textField: UITextField) {
        self.messageInputView.buttonSend.isEnabled = !textField.text.isBlank
    }
    
    @objc private func sendButtonPressed() {
        self.messageInputView.buttonSend.isEnabled = false
        messageManager.sendMessage(self.messageInputView.inputTextView.text, to: self.channel.identifier) { [weak self] error in
            guard let safeSelf = self else { return }
            safeSelf.messageInputView.buttonSend.isEnabled = true
            
            if error != nil {
                safeSelf.presentMessage("Error sending message")
            } else {
                safeSelf.messageInputView.inputTextView.text = ""
            }
        }
    }
    
    @objc private func dismissKeybord() {
        messageInputView.inputTextView.endEditing(true)
    }
}

// MARK: - keyboard show
extension ChannelViewController {
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}

        let keyboardScreenFrame = keyboardValue.cgRectValue
        let keyboardViewFrame = view.convert(keyboardScreenFrame, from: view.window)

        let keyboardHiding = notification.name == UIResponder.keyboardWillHideNotification

        if keyboardHiding {
            self.bottomConstraint.constant = 0

        } else {
            self.keyboardHeight = keyboardViewFrame.height
            self.bottomConstraint.constant = -self.keyboardHeight
        }

        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()

            if keyboardHiding {
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y - self.keyboardHeight), animated: false)
                // именно в таком порядке, иначе таблица перескакивает
                self.tableView.scrollIndicatorInsets = .zero
                self.tableView.contentInset = .zero
            } else {
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y + self.keyboardHeight), animated: false)
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.keyboardHeight, right: 0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
            }
        }, completion: nil
        )
    }
}

// MARK: - Text view delegate
extension ChannelViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = ThemeManager.shared.theme.settings.labelColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your message here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.messageInputView.buttonSend.isEnabled = !textView.text.isBlank
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ChannelViewController: NSFetchedResultsControllerDelegate {
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
                Logger.app.logMessage("Insert", logLevel: .debug)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                Logger.app.logMessage("Delete", logLevel: .debug)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let newIndexPath = newIndexPath,
                let oldIndexPath = indexPath {
                Logger.app.logMessage("Move", logLevel: .debug)
                tableView.deleteRows(at: [oldIndexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath,
                let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell {
                Logger.app.logMessage("Update", logLevel: .debug)
                let messageDb = fetchedResultController.object(at: indexPath)
                let message = Message(messageDb)
                let messageCellModel = MessageCellModel(message: message)
                cell.configure(with: messageCellModel)
            }
        default:
            break
        }
    }
    
    /// Конец изменения
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        scrollTableToBottom()
    }
}
