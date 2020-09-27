//
//  DialogTableViewCell.swift
//  fintech_chat
//
//  Created by Admin on 9/25/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol ConfigurableView{
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

class ConversationTableViewCell: UITableViewCell {

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
    
    // MARK: - Private functions
    
    private func configureUI(){
        friendImage.layer.cornerRadius = friendImage.bounds.width / 2
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
    
    private func getString(from date: Date) -> String{
        let dateNow = Date()
        let dateFormatter = DateFormatter()
        guard date.year() == dateNow.year(),
            date.month() == dateNow.month(),
            date.day() == dateNow.day()
            else {
                dateFormatter.dateFormat = "dd MMM"
                return dateFormatter.string(from: date)
        }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

// MARK: - ConfigurableView

extension ConversationTableViewCell: ConfigurableView {
    typealias ConfigurationModel = ConversationCellModel
    
    func configure(with data: ConversationCellModel){
        friendName.text = data.name
        
        if (data.message != ""){
            var font = UIFont.systemFont(ofSize: 13)

            if (data.hasUnreadMessages){
                font = UIFont.boldSystemFont(ofSize: 13)
            }
            
            lastMessage.attributedText = NSAttributedString(string: data.message, attributes: [NSAttributedString.Key.font: font])
        }
        else {
            let text = "No messages yet"
            let font = UIFont(name: "Apple SD Gothic Neo", size: 13)
            let attributes = [NSAttributedString.Key.font: font]
            lastMessage.attributedText = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
            
        }

        lastMessageDate.text = getString(from: data.date)
        
        if (data.isOnline){
            self.backgroundColor = UIColor.AppColors.YellowLight
        }
        else{
            self.backgroundColor = UIColor.clear
        }
    }
}
