//
//  DialogTableViewCell.swift
//  fintech_chat
//
//  Created by Admin on 9/25/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

struct DialogCellData {
    var friendName: String
    var lastMessageDate: String
    var lastMessage: String?
    
    // todo may be data?
    var friendImage: UIImage?
}

class DialogTableViewCell: UITableViewCell {

    @IBOutlet private weak var friendName: UILabel!
    @IBOutlet private weak var lastMessageDate: UILabel!
    @IBOutlet private weak var lastMessage: UILabel!
    @IBOutlet private  weak var friendImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        configureUI()
    }
    
    func configureSell(withData data: DialogCellData){
        friendName.text = data.friendName
        
        if (data.lastMessage == nil){
            lastMessage.text = "lastMessage.text"
        }
        else {
            lastMessage.text = data.lastMessage
        }
        
        
        lastMessageDate.text = data.lastMessageDate
        friendImage.image = data.friendImage
    }
    
    private func configureUI(){
        friendImage.layer.cornerRadius = friendImage.bounds.width / 2
    }
}
