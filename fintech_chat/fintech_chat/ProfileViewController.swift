import UIKit
import AVFoundation

class ProfileViewController: BaseViewController {
    
    
    @IBOutlet weak var defaultPhotoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    weak var initialsLabel: UILabel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Logger.app.logMessage("\(editButton.frame)", logLevel: .Info)
        // Кнопка, как и вся view еще не начали загружаться и, следовательно, не существуют. А мы
        // пытаемся обратиться к ней. editButton nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
     
        // Logger.app.logMessage("\(editButton.frame)", logLevel: .Info)
        // Кнопка, как и вся view еще не начали загружаться и, следовательно, не существуют. А мы
        // пытаемся обратиться к ней. editButton nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        Logger.app.logMessage("\(saveButton.frame)", logLevel: .Info)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.app.logMessage("\(saveButton.frame)", logLevel: .Info)
        // Frame отличаются, потому что сначала кнопка появилась, когда safeArea еще не была просчитана автоЛейаутом. Вообще в момент
        // вызова viewDidLoad вью этого вьюКонтроллера не была добавлена в иерархию приложения. Потом вью добавилась,
        // посчиталась safeArea и уже исходя из нее посчитались констрэинты кнопки
    }
    
    // MARK: - Private methods
    
    private func setupUI(){
        profilePhotoView.layer.cornerRadius = profilePhotoView.bounds.width / 2
        saveButton.layer.cornerRadius = saveButton.bounds.height / 3
        
        guard profilePhotoView.image == nil else { return }
        
        defaultPhotoView.layer.cornerRadius = defaultPhotoView.bounds.width / 2
        
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = fillInitials()
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 120)
//        defaultPhotoView.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.widthAnchor.constraint(equalTo: defaultPhotoView.widthAnchor),
//            label.heightAnchor.constraint(equalTo: defaultPhotoView.heightAnchor),
//            label.centerXAnchor.constraint(equalTo: defaultPhotoView.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: defaultPhotoView.centerYAnchor)
//        ])
//        initialsLabel = label
        
        let label1 = UILabel()
        let label2 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label1.text = "M"
        label2.text = "D"
        label1.textAlignment = .center
        label2.textAlignment = .center
        label1.font = UIFont.systemFont(ofSize: 120)
        label2.font = UIFont.systemFont(ofSize: 120)
        defaultPhotoView.addSubview(label1)
        defaultPhotoView.addSubview(label2)
        
        NSLayoutConstraint.activate([
            label1.trailingAnchor.constraint(equalTo: defaultPhotoView.centerXAnchor),
            label1.centerYAnchor.constraint(equalTo: defaultPhotoView.centerYAnchor),
            label1.heightAnchor.constraint(equalTo: defaultPhotoView.heightAnchor),
            
            label2.leadingAnchor.constraint(equalTo: defaultPhotoView.centerXAnchor),
            label2.centerYAnchor.constraint(equalTo: defaultPhotoView.centerYAnchor),
            label2.heightAnchor.constraint(equalTo: defaultPhotoView.heightAnchor),
        ])
    }
    
    private func fillInitials() -> String{
        guard let fullName = nameLabel.text else {return ""}
        let names = fullName.components(separatedBy: " ")
        switch(names.count){
        case 0: return ""
        case 1: return "\(names[0].prefix(1))".uppercased()
        case 2: return "\(names[0].prefix(1))\(names[1].prefix(1))".uppercased()
        default: return ""
        }
    }
    
    private func checkCameraPermission(){
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
                    self.presentMessage("You don`t allow")
                }
            }
        default:
            break
        }
    }
    
    private func presentCameraSettings(){
        let alertController = UIAlertController(title: "Error", message: "Camera access is denied", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default){(_) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        present(alertController, animated: true)
    }
    
    private func presentMessage(_ message: String){
        let alertController = UIAlertController(title: "information", message: "message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    
    @IBAction func editTouch(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose source for avatar", message: "",  preferredStyle: .actionSheet)
        
        let galery = UIAlertAction(title: "Galery", style: .default){(_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let camera = UIAlertAction(title: "Camera", style: .default){(_) in
            self.checkCameraPermission()
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
        
        profilePhotoView.image = image
        profilePhotoView.contentMode = .scaleAspectFill
        profilePhotoView.clipsToBounds = true
        
        defaultPhotoView.backgroundColor = .none
        initialsLabel?.isHidden = true
        
        dismiss(animated: true)
    }
}

