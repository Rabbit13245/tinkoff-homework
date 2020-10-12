import UIKit
import AVFoundation

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var defaultPhotoView: UIView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var gcdSaveButton: AppBackgroundButton!
    @IBOutlet weak var operationSaveButton: AppBackgroundButton!
    
    @IBOutlet weak var safeAreaButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var defaultPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var profilePhotoConstant: NSLayoutConstraint!

    weak var initialsLabel: UILabel?
    
    var editingMode = false
    
    var userName = "Dmitry Zaytcev"
    var userDescription = "iOS developer"
    var wasChange = false
    
    lazy var dataManagerFactory: DataManagerFactory = {
        let dataManagerFactory = DataManagerFactory()
        return dataManagerFactory
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeKeyboardNotifications()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeKeyboardNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTextView.endEditing(true)
        self.descriptionTextView.endEditing(true)
    }
    
    // MARK: - Private methods
    
    private func setupUI(){
        self.descriptionTextView.delegate = self
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let dataManager = self.dataManagerFactory.createDataManager(.GCD)
        
        safeAreaButtonsConstraint.constant = 30
        defaultPhotoConstraint.constant = 8
        profilePhotoConstant.constant = 8
        
        profilePhotoView.layer.cornerRadius = profilePhotoView.bounds.width / 2
        profilePhotoView.contentMode = .scaleAspectFill
        profilePhotoView.clipsToBounds = true
        
        gcdSaveButton.layer.cornerRadius = gcdSaveButton.bounds.height / 3
        gcdSaveButton.isEnabled = self.wasChange
        
        operationSaveButton.layer.cornerRadius = operationSaveButton.bounds.height / 3
        operationSaveButton.isEnabled = self.wasChange
        
        nameTextView.isEditable = self.editingMode
        
        descriptionTextView.isEditable = self.editingMode
        descriptionTextView.setLineHeight(lineHeight: 6)
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        
        editButton.isEnabled = self.editingMode
        
        guard profilePhotoView.image == nil else { return }
        
        defaultPhotoView.layer.cornerRadius = defaultPhotoView.bounds.width / 2
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        dataManager.loadName { (name, error) in
            if(!error){
                self.userName = name
                self.nameTextView.text = self.userName
            }
            dataManager.loadDescription { (description, error) in
                if (!error){
                    self.userDescription = description
                }
                self.descriptionTextView.text = self.userDescription
                label.text = Helper.app.getInitials(from: self.userName)
                self.initialsLabel = label
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func subscribeKeyboardNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeKeyboardNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if (notification.name == UIResponder.keyboardWillHideNotification){
            
            safeAreaButtonsConstraint.constant = 30
            defaultPhotoConstraint.constant = 8
            
            profilePhotoConstant.constant = 8
        }
        else{
            safeAreaButtonsConstraint.constant = 8 + keyboardViewEndFrame.height - self.view.safeAreaInsets.bottom
            
            defaultPhotoConstraint.constant = 8 - keyboardViewEndFrame.height * 2 / 3
            profilePhotoConstant.constant = 8 - keyboardViewEndFrame.height * 2 / 3
        }

        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
        self.editingMode = !self.editingMode
        self.editButton.isEnabled = self.editingMode
        
        self.descriptionTextView.isEditable = self.editingMode
        self.nameTextView.isEditable = self.editingMode
        
        if (self.editingMode){
            sender.title = "Done"
            self.descriptionTextView.backgroundColor = ThemeManager.shared.theme.settings.secondaryBackgroundColor
        }
        else{
            sender.title = "Edit profile"
            self.nameTextView.endEditing(true)
            self.descriptionTextView.endEditing(true)
            self.descriptionTextView.backgroundColor = ThemeManager.shared.theme.settings.backgroundColor
        }
    }
    
    @IBAction func gcdSaveButtonPessed(_ sender: AppBackgroundButton) {
        self.editBarButtonPressed(self.editBarButton)
        self.modifyUIForSaveData(false)
        self.initialsLabel?.text = Helper.app.getInitials(from: self.nameTextView.text)
        let dataManager = dataManagerFactory.createDataManager(.GCD)
        
        if self.nameTextView.text != self.userName,
            self.descriptionTextView.text != self.userDescription{
            dataManager.saveUserData(name: self.nameTextView.text, description: self.descriptionTextView.text){error in
                print("2")
                self.modifyUIForSaveData(true)
            }
        }
        else if self.nameTextView.text != self.userName{
            dataManager.saveUserData(name: self.nameTextView.text, description: nil){error in
                print("name")
                self.modifyUIForSaveData(true)
            }
        }
        else if self.descriptionTextView.text != self.userDescription{
            dataManager.saveUserData(name: nil, description: self.descriptionTextView.text){error in
                print("description")
                self.modifyUIForSaveData(true)
            }
        }
        
    }
    
    private func modifyUIForSaveData(_ enabled: Bool){
        if (!enabled){
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        else{
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        self.gcdSaveButton.isEnabled = false
        self.operationSaveButton.isEnabled = false
    }
    
    @IBAction func operationSaveButtonPressed(_ sender: Any) {
        print("Operaion")
        self.gcdSaveButton.isEnabled = false
        self.operationSaveButton.isEnabled = false
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

extension ProfileViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.wasChange = true
        self.gcdSaveButton.isEnabled = self.wasChange
        self.operationSaveButton.isEnabled = self.wasChange
    }
}
