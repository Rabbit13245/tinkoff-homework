//
//  MessageTableViewCell.swift
//  fintech_chat
//
//  Created by Макбук on 27.09.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
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
        let view = UIView()
        self.addSubview(view)
        view.backgroundColor = .red
        
        //view.addSubview(messageTextLabel)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
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
