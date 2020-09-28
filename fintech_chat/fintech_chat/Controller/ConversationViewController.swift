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
    
    var friendName: String?{
        didSet{
            self.navigationItem.title = friendName
        }
    }
    
    var messages : [MessageCellModel]?

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
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let message = messages?[indexPath.row]{
            let size = CGSize(width: self.view.frame.width * 0.75 - 16, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
                
            return estimatedFrame.height + 20 + 20
        }
        return 44
    }
    
    
    // MARK: - Private functions
    
    private func setupUI(){
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.separatorStyle = .none
    }
}
