//
//  ConversationsListViewController.swift
//  fintech_chat
//
//  Created by Admin on 9/25/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {

    lazy var dataGenerator: FakeDataGenerator = {
        let fakeDataGenerator = FakeDataGenerator()
        return fakeDataGenerator
    }()
    
    lazy var settingsBarButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    lazy var profileBarButton: UIBarButtonItem = {
        let someView = UIView()
        someView.backgroundColor = UIColor.AppColors.YellowLight
        someView.sizeToFit()
        someView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        let text = UILabel()
        text.text = "MD"
        someView.addSubview(text)
        
        let barButtom = UIBarButtonItem(customView: someView)
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return conversations?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?[section].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return ""
        }
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
        
        controller.messages = dataGenerator.getMessages()
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private functions
    
    private func setupUI(){
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = chatName
        
        
        self.navigationItem.leftBarButtonItem = settingsBarButton
        self.navigationItem.rightBarButtonItem = profileBarButton
        
    }
}
