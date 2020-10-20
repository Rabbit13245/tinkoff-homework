import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet private weak var channelName: UILabel!
    @IBOutlet private weak var lastMessageDate: UILabel!
    @IBOutlet private weak var lastMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        configureUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = UIColor.clear
    }

    // MARK: - Private functions

    private func configureUI() {
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }

    private func getString(from date: Date) -> String {
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
    typealias ConfigurationModel = Channel

    func configure(with data: ConfigurationModel) {
        channelName.text = data.name

        if let lastMessage = data.lastMessage,
            lastMessage != ""{
            let font = UIFont.systemFont(ofSize: 13)

            //            if (data.hasUnreadMessages){
            //                font = UIFont.systemFont(ofSize: 13, weight: .heavy)
            //            }

            self.lastMessage.attributedText = NSAttributedString(string: lastMessage, attributes: [NSAttributedString.Key.font: font
            ])

            if let lastActivity = data.lastActivity {
                self.lastMessageDate.text = getString(from: lastActivity)
            }

        } else {
            let text = "No messages yet"
            let font = UIFont(name: "Apple SD Gothic Neo", size: 13)
            let attributes = [NSAttributedString.Key.font: font]
            self.lastMessage.attributedText = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key: Any])

            self.lastMessageDate.text = ""
        }
    }
}
