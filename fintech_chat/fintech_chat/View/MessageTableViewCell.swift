//
//  MessageTableViewCell.swift
//  fintech_chat
//
//  Created by Макбук on 27.09.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    } ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private functions
    
    private func configureUI(){
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width , height: self.contentView.bounds.height))
        let view = UIView()
        view.backgroundColor = .red
        
        self.contentView.addSubview(view)
        self.contentView.addSubview(messageTextLabel)
        //view.addSubview(messageTextLabel)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        messageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50),
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            messageTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTextLabel.topAnchor.constraint(equalTo: view.topAnchor),
            messageTextLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //view.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        //self.backgroundColor = UIColor.lightGray
    }
}

// MARK: - ConfigurableView

extension MessageTableViewCell: ConfigurableView{
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: MessageCellModel) {
        messageTextLabel.text = model.text
    }
}
