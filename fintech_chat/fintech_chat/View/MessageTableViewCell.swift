import UIKit

class MessageTableViewCell: UITableViewCell {

    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true 
        return view
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let senderNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func configureUI(){
        self.contentView.addSubview(bubbleView)
        self.contentView.addSubview(messageTextLabel)
        self.contentView.addSubview(senderNameLabel)
        
        self.selectionStyle = .none
    }
}

// MARK: - ConfigurableView

extension MessageTableViewCell: ConfigurableView{
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: ConfigurationModel) {
        
        messageTextLabel.text = model.message.content
        
        switch model.direction {
        case .input:
            bubbleView.backgroundColor = ThemeManager.shared.theme.settings.inputMessageBackgroundColor
            messageTextLabel.textColor = ThemeManager.shared.theme.settings.inputMessageTextColor
            senderNameLabel.textColor = ThemeManager.shared.theme.settings.inputMessageTextColor
        case .output:
            bubbleView.backgroundColor = ThemeManager.shared.theme.settings.outputMessageBackgroundColor
            messageTextLabel.textColor = ThemeManager.shared.theme.settings.outputMessageTextColor
            senderNameLabel.textColor = ThemeManager.shared.theme.settings.outputMessageTextColor
        }
    }
}
