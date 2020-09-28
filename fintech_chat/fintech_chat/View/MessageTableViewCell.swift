//
//  MessageTableViewCell.swift
//  fintech_chat
//
//  Created by Макбук on 27.09.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private functions
    
    private func configureUI(){
        self.contentView.addSubview(bubbleView)
        self.contentView.addSubview(messageTextLabel)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            
            messageTextLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            messageTextLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            messageTextLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            messageTextLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
        ])
    }
}

// MARK: - ConfigurableView

extension MessageTableViewCell: ConfigurableView{
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: MessageCellModel) {
        messageTextLabel.text = model.text
        switch (model.direction){
        case .input:
            bubbleView.removeConstraints([
                bubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.contentView.frame.width / 4),
            bubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            ])
            
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                bubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -self.contentView.frame.width / 4),
            ])
            bubbleView.backgroundColor = UIColor.AppColors.InputMessageBackground
            break
        case .output:
            bubbleView.removeConstraints([
                bubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                bubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -self.contentView.frame.width / 4),
            ])
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.contentView.frame.width / 4),
                bubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            ])
            bubbleView.backgroundColor = UIColor.AppColors.OutputMessageBackground
            break
        }
    }
}
