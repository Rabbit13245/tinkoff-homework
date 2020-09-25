//
//  ConversationViewController.swift
//  fintech_chat
//
//  Created by Admin on 9/25/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ConversationViewController: UITableViewController {

    var friendName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = friendName
        
        self.view.backgroundColor = UIColor.red
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
