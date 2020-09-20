import UIKit

class ProfileViewController: BaseViewController {
    
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var initialsLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI(){
        photoView.layer.cornerRadius = photoView.bounds.width / 2
        saveButton.layer.cornerRadius = saveButton.bounds.height / 3
        
        let label = UILabel()
        label.text = "MD"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 120)
        photoView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: photoView.widthAnchor),
            label.heightAnchor.constraint(equalTo: photoView.heightAnchor),
            label.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: photoView.centerYAnchor)
        ])
        initialsLabel = label
    }
}


