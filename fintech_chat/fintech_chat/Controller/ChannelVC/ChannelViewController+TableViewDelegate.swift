import UIKit

// MARK: - Table view data source
extension ChannelViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageTableViewCell.self),
            for: indexPath)
            as? MessageTableViewCell else { return UITableViewCell() }

        //let message = self.messages[indexPath.row]
        let messageDb = fetchedResultController.object(at: indexPath)
        let message = Message(messageDb)
        let messageCellModel = MessageCellModel(message: message)

        cell.configure(with: messageCellModel)

        let size = CGSize(width: self.view.frame.width * 0.75 - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let estimatedFrameMessage = NSString(
            string: messageCellModel.message.content).boundingRect(with: size,
                                                           options: options,
                                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
                                                           context: nil)
        let estimatedFrameUserName = NSString(
            string: messageCellModel.message.senderName).boundingRect(
                with: size,
                options: options,
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)],
                context: nil)

        let maxWidth = estimatedFrameMessage.width > estimatedFrameUserName.width ? estimatedFrameMessage.width : estimatedFrameUserName.width

        if messageCellModel.direction == .input {
            let senderNameHeight = cell.senderNameLabel.font.pointSize
            cell.senderNameLabel.text = messageCellModel.message.senderName
            cell.senderNameLabel.isHidden = false
            cell.senderNameLabel.frame = CGRect(x: 16, y: 10, width: maxWidth, height: senderNameHeight)
            cell.messageTextLabel.frame = CGRect(x: 16, y: 10 + senderNameHeight + 2, width: maxWidth, height: estimatedFrameMessage.height)
            cell.bubbleView.frame = CGRect(x: 8, y: 0, width: maxWidth + 8 + 8, height: estimatedFrameMessage.height + 20 + senderNameHeight + 2)

        } else {
            cell.messageTextLabel.frame = CGRect(
                x: self.view.frame.width - estimatedFrameMessage.width - 16,
                y: 10,
                width: estimatedFrameMessage.width,
                height: estimatedFrameMessage.height)
            cell.bubbleView.frame = CGRect(
                x: self.view.frame.width - estimatedFrameMessage.width - 24,
                y: 0,
                width: estimatedFrameMessage.width + 16,
                height: estimatedFrameMessage.height + 20)
            cell.senderNameLabel.isHidden = true
        }

        return cell
    }
}

// MARK: - Table view delegate
extension ChannelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        //let message = self.messages[indexPath.row]
        let messageDb = fetchedResultController.object(at: indexPath)
        let message = Message(messageDb)
        
        let messageCellModel = MessageCellModel(message: message)

        let size = CGSize(width: self.view.frame.width * 0.75 - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let estimatedFrame = NSString(
            string: messageCellModel.message.content).boundingRect(
                with: size,
                options: options,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
                context: nil)

        if messageCellModel.direction == .input {
            return estimatedFrame.height + 20 + 6 + 14
        } else {
            return estimatedFrame.height + 20 + 6
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextView.endEditing(true)
    }
}
