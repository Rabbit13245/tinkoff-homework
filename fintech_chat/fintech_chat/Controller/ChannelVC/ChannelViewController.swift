import UIKit
import CoreData

class ChannelViewController: UIViewController {

    //private var channelName: String

    /// id в firebase
    //private var channelId: String

    /// Канал, по которому будем выводить сообщения
    private var channel: ChannelDb
    
    private let cellIdentifier = String(describing: MessageTableViewCell.self)

    private var keyboardHeight: CGFloat = 0

    private var sendMessageButton: UIButton?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()

    internal lazy var inputTextView: AppChatTextView = {
        let textView = AppChatTextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Your message here..."
        textView.textColor = UIColor.lightGray

        textView.delegate = self

        textView.layer.cornerRadius = 16

        return textView
    }()

    private lazy var messageInputView: AppTextWrapperView = {
        let view = AppTextWrapperView()
        return view
    }()

    private lazy var bottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: messageInputView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        return constraint
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.isHidden = true
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

    init(channel: ChannelDb) {
        self.channel = channel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        do {
            try fetchedResultController.performFetch()
            self.tableView.reloadData()
        } catch {
            Logger.app.logMessage("FRC messages error: \(error.localizedDescription)", logLevel: .error)
        }
        
        loadMessagesFromFirebase()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        unsubscribeKeyboardNotifications()
    }

    // MARK: - Private functions
    private func scrollTableToBottom() {
        // todo: - не сделано
//        if !self.messages.isEmpty {
//            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
//        }
    }
    
    private func loadMessagesFromFirebase() {
        FirebaseManager.shared.getAllMessages(from: self.channel.identifier) {[weak self] (result) in
            guard let safeSelf = self else { return }
            switch result {
            case .success(let documentChanges):
                var modified = [Message]()
                var added = [Message]()
                var removed = [Message]()
                
                for change in documentChanges {
                    guard let channel = Message(change.document) else { continue }
                    switch change.type {
                    case .added:
                        added.append(channel)
                    case .removed:
                        removed.append(channel)
                    case .modified:
                        modified.append(channel)
                    }
                }
                
                CoreDataStack.shared.addNewMessages(added, for: safeSelf.channel.objectID)
            case .failure:
                safeSelf.noMessagesLabel.isHidden = false
            }
        }
    }

    private func setupUI() {
        self.view = AppView()

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

        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomConstraint,
            messageInputView.heightAnchor.constraint(equalToConstant: 80)
        ])

        let buttonAdd = UIButton(type: .contactAdd)
        
        let buttonSend = UIButton(type: .roundedRect)
        buttonSend.setTitle("Send", for: .normal)
        buttonSend.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        buttonSend.isEnabled = false
        self.sendMessageButton = buttonSend
        
        let stackView = UIStackView(arrangedSubviews: [buttonAdd, inputTextView, buttonSend])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        messageInputView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: messageInputView.topAnchor, constant: 16),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: messageInputView.heightAnchor, multiplier: 0.5),

            inputTextView.heightAnchor.constraint(equalToConstant: 40)
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
    
    private func presentMessage(_ message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.applyTheme()

        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: - actions
extension ChannelViewController {
    @objc func messageTextFieldDidChange(_ textField: UITextField) {
        self.sendMessageButton?.isEnabled = !textField.text.isBlank
    }
    
    @objc private func sendButtonPressed() {
        self.sendMessageButton?.isEnabled = false
        FirebaseManager.shared.sendMessage(self.inputTextView.text, to: self.channel.identifier) { [weak self] error in
            guard let safeSelf = self else { return }
            safeSelf.sendMessageButton?.isEnabled = true
            
            if error != nil {
                safeSelf.presentMessage("Error sending message")
            } else {
                safeSelf.inputTextView.text = ""
            }
        }
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText = currentText + text
        var canSend = false

        // удаляем что-то
        if text == "" {
            if newText != "",
                let stringRange = Range(range, in: currentText) {
                let newString = currentText.replacingCharacters(in: stringRange, with: text)
                if !newString.isBlank {
                    canSend = true
                }
            }
        } else {
            canSend = !newText.isBlank
        }
        
        self.sendMessageButton?.isEnabled = canSend
    
        return true
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
//                Logger.app.logMessage("Insert", logLevel: .info)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
//                Logger.app.logMessage("Delete", logLevel: .info)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let newIndexPath = newIndexPath,
                let oldIndexPath = indexPath {
//                Logger.app.logMessage("Move", logLevel: .info)
                tableView.deleteRows(at: [oldIndexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath,
                let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell {
//                Logger.app.logMessage("Update", logLevel: .info)
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
    }
}
