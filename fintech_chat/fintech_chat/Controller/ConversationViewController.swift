import UIKit

class ConversationViewController: UIViewController {

    lazy var dataGenerator: FakeDataGenerator = {
        let fakeDataGenerator = FakeDataGenerator()
        return fakeDataGenerator
    }()
    
    var friendName: String?
    
    var friendAvatar: UIImage?
    
    var messages : [MessageCellModel]?

    private let cellIdentifier = String(describing: MessageTableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var inputTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Your message here..."
        textView.textColor = UIColor.lightGray
        
        textView.delegate = self
        
        textView.layer.cornerRadius = 16
        textView.backgroundColor = UIColor.white
        
        return textView
    }()
    
    private lazy var bottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: messageInputView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        return constraint
    }()
    
    let messageInputView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.AppColors.inputTextContainerGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeKeyboardNotifications()
    }
    
    // MARK: - Private functions
    
    private func setupUI(){
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
        setupNavTitle()
        setupInputView()
        setupTableView()
        subscribeKeyboardNotifications()
    }
    
    private func setupTableView(){
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.messageInputView.topAnchor),
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
        
        let label = UILabel()
        label.text = friendName
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
        var avatarView :UIView = UIView()
        
        let miniAvatarSize: CGFloat = 36
        
        if (friendAvatar != nil){
            let navImage = UIImageView()
            
            navImage.image = friendAvatar
            navImage.contentMode = .scaleAspectFit
            navImage.clipsToBounds = true
            navImage.contentMode = .scaleAspectFit
            navImage.layer.cornerRadius = miniAvatarSize / 2
            
            avatarView = navImage
        }
        else {
            let someView = Helper.app.generateDefaultAvatar(name: friendName ?? "", width: miniAvatarSize)
            
            avatarView = someView
        }
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: miniAvatarSize),
            avatarView.heightAnchor.constraint(equalToConstant: miniAvatarSize),
        ])
        
        let stackView = UIStackView(arrangedSubviews: [avatarView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        
        self.navigationItem.titleView = stackView
    }
    
    private func subscribeKeyboardNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeKeyboardNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardScreenFrame = keyboardValue.cgRectValue
        let keyboardViewFrame = view.convert(keyboardScreenFrame, from: view.window)
        
        let keyboardHiding = notification.name == UIResponder.keyboardWillHideNotification
        
        var lastPath : IndexPath?
        if let paths = self.tableView.indexPathsForVisibleRows{
            lastPath = paths.last
        }
        
        if (keyboardHiding){
            bottomConstraint.constant = 0
        }
        else{
            bottomConstraint.constant = -keyboardViewFrame.height
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {(completed) in
            if (!keyboardHiding){
                if let lastPath = lastPath{
                    self.tableView.scrollToRow(at: lastPath, at: .bottom, animated: true)
                }
            }
        })
    }
}

// MARK: - Table view data source
extension ConversationViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageTableViewCell.self), for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        let message = messages?[indexPath.row] ?? dataGenerator.getDefaultMessage()
        
        cell.configure(with: message)
        
        let size = CGSize(width: self.view.frame.width * 0.75 - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
        
        if (message.direction == .input){
            cell.messageTextLabel.frame = CGRect(x: 16, y: 10, width: estimatedFrame.width, height: estimatedFrame.height)
            
            cell.bubbleView.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width + 8 + 8, height: estimatedFrame.height + 20)
        }
        else{
            cell.messageTextLabel.frame = CGRect(x: self.view.frame.width - estimatedFrame.width - 16, y: 10, width: estimatedFrame.width, height: estimatedFrame.height)
            
            cell.bubbleView.frame = CGRect(x: self.view.frame.width - estimatedFrame.width - 24, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
        }
        
        return cell
    }
}

// MARK: - Table view delegate
extension ConversationViewController: UITableViewDelegate{
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
extension ConversationViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your message here..."
            textView.textColor = UIColor.lightGray
        }
    }
}
