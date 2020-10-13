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
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var safeAreaButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var defaultPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var profilePhotoConstant: NSLayoutConstraint!

    weak var initialsLabel: UILabel?
    
    var editingMode = false
    var imageChanged = false
    
    var userName = "Dmitry Zaytcev"
    var userDescription = "iOS developer"
    var userImage: UIImage? = nil
    
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
        descriptionTextView.delegate = self
        nameTextView.delegate = self
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.color = ThemeManager.shared.theme.settings.labelColor
        
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
        
        let dataManager = self.dataManagerFactory.createDataManager(.GCD)
        
        dataManager.loadName { (name, error) in
            if(!error){
                self.userName = name
                self.nameTextView.text = self.userName
            }
            dataManager.loadDescription { (description, error) in
                if (!error){
                    self.userDescription = description
                }
                dataManager.loadImage { (image, error) in
                    if(!error){
                        self.userImage = image
                        self.profilePhotoView.image = self.userImage
                    }
                    
                    self.descriptionTextView.text = self.userDescription
                    
                    label.text = Helper.app.getInitials(from: self.userName)
                    self.initialsLabel = label
                    
                    if(self.userImage != nil){
                        self.defaultPhotoView.backgroundColor = .none
                        self.initialsLabel?.isHidden = true
                    }
                    
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
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
            
            stackViewTopConstraint.constant = 30
        }
        else{
            safeAreaButtonsConstraint.constant = 8 + keyboardViewEndFrame.height - self.view.safeAreaInsets.bottom
            
            stackViewTopConstraint.constant = 10
            
            defaultPhotoConstraint.constant =  8 - keyboardViewEndFrame.height * 4 / 5
            profilePhotoConstant.constant = 8 - keyboardViewEndFrame.height * 4 / 5
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
        let dataManager = dataManagerFactory.createDataManager(.GCD)
        self.internalSaveData(dataManager)
    }
    
    @IBAction func operationSaveButtonPressed(_ sender: Any) {
        let dataManager = dataManagerFactory.createDataManager(.Operation)
        
        self.internalSaveData(dataManager)
    }
    
    private func internalSaveData(_ dataManager: DataManagerProtocol){
        // если нажали в режиме редактирования, то выходим из него
        if (self.editingMode){
            self.editBarButtonPressed(self.editBarButton)
        }
        
        self.modifyUIForSaveData(false)
        
        self.initialsLabel?.text = Helper.app.getInitials(from: self.nameTextView.text)
        
        let imageForSave: UIImage? = self.userImage == self.profilePhotoView.image ? nil : self.profilePhotoView.image
        
        if self.nameTextView.text != self.userName,
            self.descriptionTextView.text != self.userDescription{
            dataManager.saveUserData(name: self.nameTextView.text, description: self.descriptionTextView.text, image: imageForSave){
                (response, error) in
                self.modifyUIForSaveData(true)
                if(error){
                    self.updateDataAfterSave(response: response)
                    
                    self.failedSaveData(){
                        self.internalSaveData(dataManager)
                    }
                }
                else{
                    self.succesSaveData()
                }
            }
        }
        else if self.nameTextView.text != self.userName{
            dataManager.saveUserData(name: self.nameTextView.text, description: nil, image: imageForSave){
                (response, error) in
                self.modifyUIForSaveData(true)
                if(error){
                    self.updateDataAfterSave(response: response)
                    
                    self.failedSaveData(){
                        self.internalSaveData(dataManager)
                    }
                }
                else{
                    self.succesSaveData()
                }
            }
        }
        else if self.descriptionTextView.text != self.userDescription{
            dataManager.saveUserData(name: nil, description: self.descriptionTextView.text, image: imageForSave){
                (response, error) in
                self.modifyUIForSaveData(true)
                if(error){
                    self.updateDataAfterSave(response: response)
                    
                    self.failedSaveData(){
                        self.internalSaveData(dataManager)
                    }
                }
                else{
                    self.succesSaveData()
                }
            }
        }
        else if self.userImage != self.profilePhotoView.image{
            dataManager.saveUserData(name: nil, description: nil, image: self.profilePhotoView.image){
                (response, error) in
                self.modifyUIForSaveData(true)
                if(error){
                    self.updateDataAfterSave(response: response)
                    
                    self.failedSaveData(){
                        self.internalSaveData(dataManager)
                    }
                }
                else{
                    self.succesSaveData()
                }
            }
        }
    }
    
    private func updateDataAfterSave(response: Response?){
        if let response = response{
            if (!response.nameError){
                self.userName = self.nameTextView.text
            }
            if (!response.descriptionError){
                self.userDescription = self.descriptionTextView.text
            }
            if(!response.imageError){
                self.userImage = self.profilePhotoView.image
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
        self.editBarButton.isEnabled = enabled
    }
    
    private func succesSaveData(){
        let alertController = UIAlertController(title: "Data saved", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    private func failedSaveData( completion: @escaping (()->Void)){
        let alertController = UIAlertController(title: "Eroor", message: "Failed to save data", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        let repeatAction = UIAlertAction(title: "Repeat", style: .default) { (action) in
            completion()
        }
        alertController.addAction(repeatAction)
        self.present(alertController, animated: true)
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
        
        self.wasChange = true
        self.gcdSaveButton.isEnabled = self.wasChange
        self.operationSaveButton.isEnabled = self.wasChange
        
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
