//
//  ConversationViewController.swift
//  fintech_chat
//
//  Created by Admin on 9/25/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ConversationViewController: UITableViewController {

    lazy var dataGenerator: FakeDataGenerator = {
        let fakeDataGenerator = FakeDataGenerator()
        return fakeDataGenerator
    }()
    
    var friendName: String?
    
    var friendAvatar: UIImage?
    
    var messages : [MessageCellModel]?

    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your message here..."
        return textField
    }()
    
    let messageInputView: UIView = {
       let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: String(describing: MessageTableViewCell.self))
        
        setupUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageTableViewCell.self), for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        let message = messages?[indexPath.row] ?? dataGenerator.getDefaultMessage()
        
        cell.configure(with: message)
        
        let size = CGSize(width: self.view.frame.width * 0.75, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
        
        if (message.direction == .input){
            cell.messageTextLabel.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width, height: estimatedFrame.height + 20)
            
            cell.bubbleView.frame = CGRect(x: 0, y: 0, width: estimatedFrame.width + 8 + 8, height: estimatedFrame.height + 20)
        }
        else{
            cell.messageTextLabel.frame = CGRect(x: self.view.frame.width - estimatedFrame.width, y: 0, width: estimatedFrame.width - 8, height: estimatedFrame.height + 20)
            
            cell.bubbleView.frame = CGRect(x: self.view.frame.width - estimatedFrame.width - 8, y: 0, width: estimatedFrame.width + 8, height: estimatedFrame.height + 20)
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let message = messages?[indexPath.row]{
            let size = CGSize(width: self.view.frame.width * 0.75, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
                
            return estimatedFrame.height + 20 + 20
        }
        return 44
    }
    
    // MARK: - Private functions
    
    private func setupUI(){
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        setupNavTitle()
        
        self.view.addSubview(messageInputView)
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            messageInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            messageInputView.heightAnchor.constraint(equalToConstant: 48)
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
}
