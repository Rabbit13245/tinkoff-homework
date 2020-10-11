import UIKit
import AVFoundation

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var defaultPhotoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var gcdSaveButton: AppBackgroundButton!
    @IBOutlet weak var operationSaveButton: AppBackgroundButton!
    
    weak var initialsLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI(){
        profilePhotoView.layer.cornerRadius = profilePhotoView.bounds.width / 2
        profilePhotoView.contentMode = .scaleAspectFill
        profilePhotoView.clipsToBounds = true
        
        descriptionLabel.setLineHeight(lineHeight: 6)
        
        gcdSaveButton.layer.cornerRadius = gcdSaveButton.bounds.height / 3
        operationSaveButton.layer.cornerRadius = gcdSaveButton.bounds.height / 3
        
        guard profilePhotoView.image == nil else { return }
        
        defaultPhotoView.layer.cornerRadius = defaultPhotoView.bounds.width / 2
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Helper.app.getInitials(from: nameLabel.text ?? "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 120)
        label.textColor = UIColor.AppColors.initialsColor
        label.backgroundColor = .clear
        defaultPhotoView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: defaultPhotoView.widthAnchor),
            label.heightAnchor.constraint(equalTo: defaultPhotoView.heightAnchor),
            label.centerXAnchor.constraint(equalTo: defaultPhotoView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: defaultPhotoView.centerYAnchor)
        ])
        initialsLabel = label
    }
    
    private func checkCameraPermission(){
        if (UIImagePickerController.isCameraDeviceAvailable(.rear) || UIImagePickerController.isCameraDeviceAvailable(.front)) {
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraStatus {
            case .denied:
                self.presentCameraSettings()
                break
            case .restricted:
                self.presentMessage("You don`t allow")
                break
            case .authorized:
                self.chooseImagePicker(source: .camera)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video){(success) in
                    if (success){
                        self.chooseImagePicker(source: .camera)
                    }
                    else{
                        self.presentMessage("Camera access is denied")
                    }
                }
            default:
                break
            }
        }
        else{
            self.presentMessage("Your camera is not available")
        }
    }
    
    private func presentCameraSettings(){
        let alertController = UIAlertController(title: "Error", message: "Camera access is denied", preferredStyle: .alert)
        alertController.setBackground(color: ThemeManager.shared.theme.settings.secondaryBackgroundColor)
        alertController.setTitle(color: ThemeManager.shared.theme.settings.labelColor)
        alertController.setMessage(color: ThemeManager.shared.theme.settings.labelColor)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default){(_) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        present(alertController, animated: true)
    }
    
    private func presentMessage(_ message: String){
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.setBackground(color: ThemeManager.shared.theme.settings.secondaryBackgroundColor)
        alertController.setTitle(color: ThemeManager.shared.theme.settings.labelColor)
        alertController.setMessage(color: ThemeManager.shared.theme.settings.labelColor)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func editTouch(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil,  preferredStyle: .actionSheet)
        actionSheet.setBackground(color: ThemeManager.shared.theme.settings.secondaryBackgroundColor)
        //actionSheet.setTint(color: ThemeManager.shared.theme.settings.labelColor)
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let galery = UIAlertAction(title: "Photo Library", style: .default){(_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        galery.setValue(photoIcon, forKey: "image")
        galery.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let camera = UIAlertAction(title: "Camera", style: .default){(_) in
            self.checkCameraPermission()
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        actionSheet.addAction(galery)
        actionSheet.addAction(camera)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        print("Edit")
        
    }
    
    @IBAction func gcdSaveButtonPessed(_ sender: AppBackgroundButton) {
        print("GCD")
    }
    
    
    @IBAction func operationSaveButtonPressed(_ sender: Any) {
        print("Operaion")
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
        
        profilePhotoView.image = image
        
        defaultPhotoView.backgroundColor = .none
        initialsLabel?.isHidden = true
        
        dismiss(animated: true)
    }
}
