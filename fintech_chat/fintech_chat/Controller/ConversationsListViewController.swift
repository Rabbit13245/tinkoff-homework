//
//  ConversationsListViewController.swift
//  fintech_chat
//
//  Created by Admin on 9/25/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

struct Friend{
    let Name: String
}

class ConversationsListViewController: UITableViewController {

    var friends = [
        [
            Friend(Name: "Steve Jobs"),
            Friend(Name: "William Gates"),
            Friend(Name: "Stephen Wozniak"),
            Friend(Name: "Barack Obama"),
            Friend(Name: "Donald Trump"),
            Friend(Name: "Mark Zuckerberg"),
            Friend(Name: "Angela Merkel"),
            Friend(Name: "Elon Musk"),
            Friend(Name: "Timothy Cook"),
            Friend(Name: "Ronald Wayne"),
        ],
        [
            Friend(Name: "Hermann Gräf"),
            Friend(Name: "Oleg Tinkov"),
            Friend(Name: "Vladimir Putin"),
            Friend(Name: "Dmitry Medvedev"),
            Friend(Name: "Mikhail Mishustin"),
            Friend(Name: "Boris Yeltsin"),
            Friend(Name: "Mikhail Gorbachev"),
            Friend(Name: "Yevgeny Kaspersky"),
            Friend(Name: "David Yang"),
            Friend(Name: "Andrey Akinshin"),
        ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.register(UINib(nibName: String(describing: DialogTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DialogTableViewCell.self))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends[section].count
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DialogTableViewCell.self), for: indexPath) as? DialogTableViewCell else {return UITableViewCell()}
        
        let cellData = DialogCellData(friendName: friends[indexPath.section][indexPath.row].Name, lastMessageDate: "2020-09-25", lastMessage: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum. An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", friendImage: nil)
        
        cell.configureSell(withData: cellData)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ConversationViewController()
        controller.friendName = friends[indexPath.section][indexPath.row].Name
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private functions
    
    private func setupUI(){
        self.navigationItem.title = "Tinkoff Chat"
    }
}
