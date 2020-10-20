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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    // MARK: - Private functions
    
    private func configureUI(){
        self.contentView.addSubview(bubbleView)
        self.contentView.addSubview(messageTextLabel)
                
        self.selectionStyle = .none
    }
}

// MARK: - ConfigurableView

extension MessageTableViewCell: ConfigurableView{
    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: MessageCellModel) {
        messageTextLabel.text = model.text
        switch (model.direction){
        case .input:
            bubbleView.backgroundColor = ThemeManager.shared.theme.settings.inputMessageBackgroundColor
            messageTextLabel.textColor = ThemeManager.shared.theme.settings.inputMessageTextColor
            break
        case .output:
            bubbleView.backgroundColor = ThemeManager.shared.theme.settings.outputMessageBackgroundColor
            messageTextLabel.textColor = ThemeManager.shared.theme.settings.outputMessageTextColor
            break
        }
    }
}
