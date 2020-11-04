import UIKit
import CoreData

class ChannelViewController: UIViewController {

    private var channelName: String

    private var channelId: String

    private var messages = [Message]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.scrollTableToBottom()
            }
            saveMessagesToCoreData()
        }
    }

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

    private lazy var inputTextView: AppChatTextView = {
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
    
    private lazy var fetchedResultController: NSFetchedResultsController<MessageDb> = {
        let request: NSFetchRequest<MessageDb> = MessageDb.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sort]

        let predicate = NSPredicate(format: "channel.identifier == %@", self.channelId)
        request.predicate = predicate
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return frc
    }()

    init(channelName: String, channelId: String) {
        self.channelName = channelName
        self.channelId = channelId

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        unsubscribeKeyboardNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try fetchedResultController.performFetch()
            self.tableView.reloadData()
        } catch {
            Logger.app.logMessage("FRC messages error: \(error.localizedDescription)", logLevel: .error)
        }
        
        //loadMessagesFromFirebase()
    }

    // MARK: - Private functions
    private func saveMessagesToCoreData() {
        guard let channelFromDb = CoreDataStack.shared.getChannel(with: self.channelId) else { return }
    
        CoreDataStack.shared.performSave { [weak self] (context) in
            guard let safeSelf = self,
                let safeChannel = try? context.existingObject(with: channelFromDb.objectID) as? ChannelDb else {return}
            
            //            guard let safeSelf = self,
            //                let safeChannel = CoreDataStack.shared.getChannel(with: safeSelf.channelId, in: context) else {return}
            
            let messagesForAdd = safeSelf.messages.map {
                MessageDb(message: $0, in: context)
            }
            let setMessagesForAdd = NSSet(array: messagesForAdd)
            safeChannel.addToMessages(setMessagesForAdd)
        }
    }
    
    private func scrollTableToBottom() {
        // todo: - не сделано
        if !self.messages.isEmpty {
            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    private func loadMessagesFromFirebase() {
        self.activityIndicator.startAnimating()

        DbManager.shared.getAllMessages(from: self.channelId) {[weak self] (result) in
            guard let safeSelf = self else { return }
            safeSelf.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    safeSelf.tableView.isHidden = true
                    safeSelf.noMessagesLabel.isHidden = false
                    return
                }
                safeSelf.tableView.isHidden = false
                safeSelf.noMessagesLabel.isHidden = true

                safeSelf.messages = messages

            case .failure:
                safeSelf.tableView.isHidden = true
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
        label.text = channelName
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
        DbManager.shared.sendMessage(self.inputTextView.text, to: self.channelId) { [weak self] error in
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

// MARK: - Table view data source
extension ChannelViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageTableViewCell.self),
            for: indexPath)
            as? MessageTableViewCell else { return UITableViewCell() }

        //let message = self.messages[indexPath.row]
        let messageDb = fetchedResultController.object(at: indexPath)
        let message = Message(messageDb)
        let messageCellModel = MessageCellModel(message: message)

        cell.configure(with: messageCellModel)

        let size = CGSize(width: self.view.frame.width * 0.75 - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let estimatedFrameMessage = NSString(
            string: messageCellModel.message.content).boundingRect(with: size,
                                                           options: options,
                                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
                                                           context: nil)
        let estimatedFrameUserName = NSString(
            string: messageCellModel.message.senderName).boundingRect(
                with: size,
                options: options,
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)],
                context: nil)

        let maxWidth = estimatedFrameMessage.width > estimatedFrameUserName.width ? estimatedFrameMessage.width : estimatedFrameUserName.width

        if messageCellModel.direction == .input {
            let senderNameHeight = cell.senderNameLabel.font.pointSize
            cell.senderNameLabel.text = messageCellModel.message.senderName
            cell.senderNameLabel.isHidden = false
            cell.senderNameLabel.frame = CGRect(x: 16, y: 10, width: maxWidth, height: senderNameHeight)
            cell.messageTextLabel.frame = CGRect(x: 16, y: 10 + senderNameHeight + 2, width: maxWidth, height: estimatedFrameMessage.height)
            cell.bubbleView.frame = CGRect(x: 8, y: 0, width: maxWidth + 8 + 8, height: estimatedFrameMessage.height + 20 + senderNameHeight + 2)

        } else {
            cell.messageTextLabel.frame = CGRect(
                x: self.view.frame.width - estimatedFrameMessage.width - 16,
                y: 10,
                width: estimatedFrameMessage.width,
                height: estimatedFrameMessage.height)
            cell.bubbleView.frame = CGRect(
                x: self.view.frame.width - estimatedFrameMessage.width - 24,
                y: 0,
                width: estimatedFrameMessage.width + 16,
                height: estimatedFrameMessage.height + 20)
            cell.senderNameLabel.isHidden = true
        }

        return cell
    }
}

// MARK: - Table view delegate
extension ChannelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        //let message = self.messages[indexPath.row]
        let messageDb = fetchedResultController.object(at: indexPath)
        let message = Message(messageDb)
        
        let messageCellModel = MessageCellModel(message: message)

        let size = CGSize(width: self.view.frame.width * 0.75 - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let estimatedFrame = NSString(
            string: messageCellModel.message.content).boundingRect(
                with: size,
                options: options,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
                context: nil)

        if messageCellModel.direction == .input {
            return estimatedFrame.height + 20 + 6 + 14
        } else {
            return estimatedFrame.height + 20 + 6
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextView.endEditing(true)
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
