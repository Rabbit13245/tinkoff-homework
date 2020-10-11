//
//  DialogTableViewCell.swift
//  fintech_chat
//
//  Created by Admin on 9/25/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet private weak var friendName: UILabel!
    @IBOutlet private weak var lastMessageDate: UILabel!
    @IBOutlet private weak var lastMessage: UILabel!
    @IBOutlet private  weak var friendImage: UIImageView!
    @IBOutlet weak var onlineCircle: UIView!
    @IBOutlet weak var defaultAvatarView: UIView!
    
    var defaultAvatar: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = UIColor.clear
        self.onlineCircle.isHidden = true
        defaultAvatar?.removeFromSuperview()
    }
    
    // MARK: - Private functions
    
    private func configureUI(){
        friendImage.layer.cornerRadius = friendImage.bounds.width / 2
        
        onlineCircle.layer.cornerRadius = onlineCircle.bounds.width / 2
        onlineCircle.backgroundColor = UIColor.AppColors.OnlineGreen
        onlineCircle.layer.borderWidth = 2
        onlineCircle.layer.borderColor = UIColor.white.cgColor
        
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
                font = UIFont.systemFont(ofSize: 13, weight: .heavy)
            }
            
            lastMessage.attributedText = NSAttributedString(string: data.message, attributes: [NSAttributedString.Key.font: font])
            
            lastMessageDate.text = getString(from: data.date)
        }
        else {
            let text = "No messages yet"
            let font = UIFont(name: "Apple SD Gothic Neo", size: 13)
            let attributes = [NSAttributedString.Key.font: font]
            lastMessage.attributedText = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
            
            lastMessageDate.text = ""
        }

        if (data.isOnline){
            self.backgroundColor = UIColor.AppColors.YellowLight
            self.onlineCircle.isHidden = false
        }
        
        if let avatar = data.avatar{
            friendImage.image = avatar
        }
        else{
            friendImage.image = nil
            defaultAvatar = Helper.app.generateDefaultAvatar(name: data.name, width: friendImage.frame.width)
            guard let defaultAvatar = defaultAvatar else {return}
            defaultAvatarView.insertSubview(defaultAvatar, belowSubview: onlineCircle)
        }
    }
}
