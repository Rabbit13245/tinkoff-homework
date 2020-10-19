import UIKit

class ChannelViewController: UIViewController {
    
    private var channelName: String
    
    private var messages : [MessageCellModel]?

    private let cellIdentifier = String(describing: MessageTableViewCell.self)
    
    private var keyboardHeight: CGFloat = 0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var inputTextView : AppChatTextView = {
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
    
    init(channelName: String){
        self.channelName = channelName
        
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
        
        self.activityIndicator.startLoading()
        DbManager.shared.getAllMessages(from: self.channelName) { (result) in
            switch result{
            case .success(let messages):
                self.activityIndicator.stopLoading()
                guard !messages.isEmpty else {
                    self.tableView.isHidden = true
                    self.noMessagesLabel.isHidden = false
                    return
                }
                self.tableView.isHidden = false
                self.noMessagesLabel.isHidden = true
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure( _):
                self.activityIndicator.stopLoading()
                self.tableView.isHidden = true
                self.noMessagesLabel.isHidden = false
            }
        }
    }
    
    // MARK: - Private functions
    
    private func setupUI(){
        self.view = AppView()
        
        setupNavTitle()
        setupTableView()
        setupInputView()
        setupActivityIndicator()
        
        subscribeKeyboardNotifications()
    }
    
    private func setupActivityIndicator(){
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.noMessagesLabel)
        
        NSLayoutConstraint.activate([
            self.noMessagesLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.noMessagesLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    private func setupTableView(){
        self.tableView.tableFooterView = AppView()
        self.tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80),
        ])
    }
    
    private func setupInputView(){
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
    
    private func setupNavTitle(){
        self.navigationItem.largeTitleDisplayMode = .never
        
        let label = AppLabel()
        label.text = channelName
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
        self.navigationItem.titleView = label
    }
    
    private func subscribeKeyboardNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeKeyboardNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

// MARK: - keyboard show
extension ChannelViewController{
    @objc private func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardScreenFrame = keyboardValue.cgRectValue
        let keyboardViewFrame = view.convert(keyboardScreenFrame, from: view.window)
        
        let keyboardHiding = notification.name == UIResponder.keyboardWillHideNotification
        
        if (keyboardHiding){
            self.bottomConstraint.constant = 0
            
        }
        else{
            self.keyboardHeight = keyboardViewFrame.height
            self.bottomConstraint.constant = -self.keyboardHeight
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            if (keyboardHiding){
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y - self.keyboardHeight), animated: false)
                // именно в таком порядке, иначе таблица перескакивает
                self.tableView.scrollIndicatorInsets = .zero
                self.tableView.contentInset = .zero
            }
            else{
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y + self.keyboardHeight), animated: false)
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.keyboardHeight, right: 0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
            }
        }, completion: nil
        )
    }
    
}

// MARK: - Table view data source
extension ChannelViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageTableViewCell.self), for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        //cell.configure(with: message)
        
//        let size = CGSize(width: self.view.frame.width * 0.75 - 16, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        let estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
//
//        if (message.direction == .input){
//            cell.messageTextLabel.frame = CGRect(x: 16, y: 10, width: estimatedFrame.width, height: estimatedFrame.height)
//
//            cell.bubbleView.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width + 8 + 8, height: estimatedFrame.height + 20)
//        }
//        else{
//            cell.messageTextLabel.frame = CGRect(x: self.view.frame.width - estimatedFrame.width - 16, y: 10, width: estimatedFrame.width, height: estimatedFrame.height)
//
//            cell.bubbleView.frame = CGRect(x: self.view.frame.width - estimatedFrame.width - 24, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
//        }
        
        return cell
    }
}

// MARK: - Table view delegate
extension ChannelViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let message = messages?[indexPath.row]{
            let size = CGSize(width: self.view.frame.width * 0.75, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
                
            return estimatedFrame.height + 20 + 20
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextView.endEditing(true)
    }
}

// MARK: - Text view delegate
extension ChannelViewController : UITextViewDelegate{
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
}
