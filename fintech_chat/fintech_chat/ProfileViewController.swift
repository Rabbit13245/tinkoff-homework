import UIKit

class ProfileViewController: BaseViewController {
    
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    weak var initialsLabel: UILabel?
    weak var profileImageVIew: UIImageView?
    
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
        
        let imageView = UIImageView()
        imageView.image = nil
        photoView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: photoView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: photoView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: photoView.centerYAnchor)
        ])
//        imageView.layer.cornerRadius = imageView.bounds.width / 2
//        profileImageVIew = imageView
    }
    
    
    @IBAction func editTouch(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose avatar", message: "Ololo", preferredStyle: .actionSheet)
        
        let galery = UIAlertAction(title: "Galery", style: .default){(_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let camera = UIAlertAction(title: "Camera", style: .default){(_) in
            self.chooseImagePicker(source: .camera)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(galery)
        actionSheet.addAction(camera)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if (UIImagePickerController.isSourceTypeAvailable(source)){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            present(imagePicker, animated: true)

        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        
        profileImageVIew?.image = image
        profileImageVIew?.contentMode = .scaleAspectFill
        profileImageVIew?.clipsToBounds = true
        
        initialsLabel?.isHidden = true
        
        dismiss(animated: true)
    }
}

