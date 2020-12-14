import UIKit

struct AvatarDisplayModel {
    var avatar: UIImage?
    let imageUrl: URL
    
    init?(apiModel: ImageApiModel) {
        guard let url = URL(string: apiModel.webformatURL) else { return nil }
        imageUrl = url
    }
}
