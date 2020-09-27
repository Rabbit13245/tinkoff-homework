//
//  MessageTableViewCell.swift
//  fintech_chat
//
//  Created by Макбук on 27.09.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    //@IBOutlet weak var messageLabel: UILabel!
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    } ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            print("FF")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("DD")
     
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
        
        //view.addSubview(messageTextLabel)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
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
