import UIKit
import CoreData

class ChannelViewControllerDelegate: NSObject, UITableViewDelegate {
    
    private var fetchedResultController: NSFetchedResultsController<MessageDb>
    private weak var vc: ChannelViewController?
    
    init(frc: NSFetchedResultsController<MessageDb>, vc: ChannelViewController) {
        fetchedResultController = frc
        self.vc = vc
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let vc = vc else {
            return 80
        }
        
        //let message = self.messages[indexPath.row]
        let messageDb = fetchedResultController.object(at: indexPath)
        let message = Message(messageDb)
        
        let messageCellModel = MessageCellModel(message: message)

        let size = CGSize(width: vc.view.frame.width * 0.75 - 16, height: 1000)
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
}
