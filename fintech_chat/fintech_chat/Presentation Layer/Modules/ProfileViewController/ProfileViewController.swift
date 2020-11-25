import UIKit
import AVFoundation

// TODO Вынести view в отдельный файл

class ProfileViewController: LoggedViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var defaultPhotoView: UIView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var gcdSaveButton: AppBackgroundButton!
    @IBOutlet weak var operationSaveButton: AppBackgroundButton!
    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var safeAreaButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var defaultPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var profilePhotoConstant: NSLayoutConstraint!

    private lazy var editButtonForBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit profile", for: .normal)
        button.addTarget(self, action: #selector(editBarButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var initialsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 120)
        label.textColor = UIColor.AppColors.initialsColor
        label.backgroundColor = .clear

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - IBActions

    @IBAction func editTouch(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.pruneNegativeWidthConstraints()
        actionSheet.applyTheme()

        let galery = UIAlertAction(title: "Photo Library", style: .default) {(_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let photoIcon = #imageLiteral(resourceName: "photo")
        galery.setValue(photoIcon, forKey: "image")
        galery.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let camera = UIAlertAction(
            title: "Camera",
            style: .default,
            handler: { [weak self] (_) in
                guard let access = self?.cameraManager?.checkCameraPermission(),
                      let ac = self?.cameraManager?.cameraSettings() else { return }
                if access {
                    self?.chooseImagePicker(source: .camera)
                } else {
                    self?.present(ac, animated: true, completion: nil)
                }
            })
        let cameraIcon = #imageLiteral(resourceName: "camera")
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let load = UIAlertAction(title: "Load", style: .default) { [weak self] (_) in
            guard let safeSelf = self else { return }
            guard let avatarLoadVC = self?.presentationAssembly?.avatarLoadViewController(delegate: safeSelf) else { return }
            self?.present(avatarLoadVC, animated: true, completion: nil)
        }
        let loadIcon = #imageLiteral(resourceName: "download")
        load.setValue(loadIcon, forKey: "image")
        load.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        actionSheet.addAction(galery)
        actionSheet.addAction(camera)
        actionSheet.addAction(load)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true)
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        animator?.stopShake(editButtonForBarButton)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func editBarButtonPressed(_ sender: UIButton) {
        self.editingMode = !self.editingMode
        
        self.editButton.isEnabled = self.editingMode
        self.avatarButton.isEnabled = self.editingMode
        self.descriptionTextView.isEditable = self.editingMode
        self.nameTextView.isEditable = self.editingMode
        descriptionTextView.isUserInteractionEnabled = self.editingMode
        nameTextView.isUserInteractionEnabled = self.editingMode
        
        if self.editingMode {
            // sender.title = "Done"
            self.descriptionTextView.backgroundColor = ThemeManager.shared.theme.settings.secondaryBackgroundColor
            self.nameTextView.backgroundColor = ThemeManager.shared.theme.settings.secondaryBackgroundColor
            
            animator?.startShake(sender)
        } else {
            // sender.title = "Edit profile"
            self.nameTextView.endEditing(true)
            self.descriptionTextView.endEditing(true)
            self.descriptionTextView.backgroundColor = ThemeManager.shared.theme.settings.backgroundColor
            self.nameTextView.backgroundColor = ThemeManager.shared.theme.settings.backgroundColor
            
            animator?.stopShake(sender)
        }
    }

    @IBAction func gcdSaveButtonPessed(_ sender: AppBackgroundButton) {
        guard let dataManager = dataManagerFactory?.createDataManager(.GCD) else { return }
        self.internalSaveData(dataManager)
    }

    @IBAction func operationSaveButtonPressed(_ sender: Any) {
        guard let dataManager = dataManagerFactory?.createDataManager(.operation) else { return }
        self.internalSaveData(dataManager)
    }
    
    // MARK: - Dependencies
    
    private var presentationAssembly: IPresentationAssembly?
    private var dataManagerFactory: IDataManagerFactory?
    private var cameraManager: ICameraManager?
    private var animator: IAnimator?
    
    public func setupDependencies(cameraManager: ICameraManager,
                                  dataManagerFactory: IDataManagerFactory,
                                  presentationAssembly: IPresentationAssembly,
                                  animator: IAnimator) {
        self.cameraManager = cameraManager
        self.dataManagerFactory = dataManagerFactory
        self.presentationAssembly = presentationAssembly
        self.animator = animator
    }
    
    // MARK: - Private properties
    
    private var editingMode = false
    private var imageChanged = false

    private var userName = ""
    private var userDescription = ""
    private var userImage: UIImage?

    private var wasChange = false
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeKeyboardNotifications()
        setupUI()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButtonForBarButton)
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

    private func setupUI() {
        descriptionTextView.delegate = self
        nameTextView.delegate = self

        nameTextView.text = self.userName
        descriptionTextView.text = self.userDescription

        descriptionTextView.layer.cornerRadius = 16
        nameTextView.layer.cornerRadius = 16

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
        avatarButton.isEnabled = self.editingMode
        
        descriptionTextView.isUserInteractionEnabled = self.editingMode
        nameTextView.isUserInteractionEnabled = self.editingMode
        
        guard profilePhotoView.image == nil else { return }

        defaultPhotoView.layer.cornerRadius = defaultPhotoView.bounds.width / 2

        defaultPhotoView.addSubview(self.initialsLabel)

        NSLayoutConstraint.activate([
            self.initialsLabel.widthAnchor.constraint(equalTo: defaultPhotoView.widthAnchor),
            self.initialsLabel.heightAnchor.constraint(equalTo: defaultPhotoView.heightAnchor),
            self.initialsLabel.centerXAnchor.constraint(equalTo: defaultPhotoView.centerXAnchor),
            self.initialsLabel.centerYAnchor.constraint(equalTo: defaultPhotoView.centerYAnchor)
        ])

        // чтение gcd
        guard let dataManagerGCD = dataManagerFactory?.createDataManager(.GCD) else { return }
        readData(dataManagerGCD)

        // чтение operations
        //guard let dataManagerOperations = dataManagerFactory?.createDataManager(.operation) else { return }
        //readData(dataManagerOperations)

        self.editButtonForBarButton.isEnabled = false
    }

    private func readData(_ dataManager: IDataManager) {
        dataManager.loadUserData { (userData, response) in
            if let resp = response {
                if !resp.nameError {
                    self.userName = userData.userName ?? "Error Load Name"
                    self.nameTextView.text = self.userName
                }
                if !resp.descriptionError {
                    self.userDescription = userData.userDescription ?? "Error Load Description"
                }
                if !resp.imageError {
                    self.userImage = userData.userImage
                    self.profilePhotoView.image = self.userImage
                }

                self.descriptionTextView.text = self.userDescription

                self.initialsLabel.text = Helper.app.getInitials(from: self.userName)

                if self.userImage != nil {
                    self.defaultPhotoView.backgroundColor = .none
                    self.initialsLabel.isHidden = true
                }

                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.editButtonForBarButton.isEnabled = true
            }
        }
    }

    private func subscribeKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unsubscribeKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func adjustKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            safeAreaButtonsConstraint.constant = 30
            defaultPhotoConstraint.constant = 8
            profilePhotoConstant.constant = 8
            stackViewTopConstraint.constant = 30
        } else {
            safeAreaButtonsConstraint.constant = 8 + keyboardViewEndFrame.height - self.view.safeAreaInsets.bottom
            stackViewTopConstraint.constant = 10
            defaultPhotoConstraint.constant = 8 - keyboardViewEndFrame.height * 4 / 5
            profilePhotoConstant.constant = 8 - keyboardViewEndFrame.height * 4 / 5
        }

        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func internalSaveData(_ dataManager: IDataManager) {
        // если нажали в режиме редактирования, то выходим из него
        if self.editingMode {
            self.editBarButtonPressed(self.editButtonForBarButton)
        }
        self.modifyUIForSaveData(false)
        self.initialsLabel.text = Helper.app.getInitials(from: self.nameTextView.text)

        if self.nameTextView.text != self.userName,
            self.descriptionTextView.text != self.userDescription {
            dataManager.saveUserData(
            name: self.nameTextView.text,
            description: self.descriptionTextView.text,
            oldImage: self.userImage,
            newImage: self.profilePhotoView.image) { [weak self] (response, error) in
                self?.modifyUIForSaveData(true)
                self?.updateDataAfterSave(response: response)
                
                if error {
                    self?.failedSaveData {
                        self?.internalSaveData(dataManager)
                    }
                } else {
                    self?.succesSaveData(title: "Data saved")
                }
            }
        } else if self.nameTextView.text != self.userName {
            dataManager.saveUserData(
            name: self.nameTextView.text,
            description: nil,
            oldImage: self.userImage,
            newImage: self.profilePhotoView.image) { [weak self] (response, error) in
                self?.modifyUIForSaveData(true)
                self?.updateDataAfterSave(response: response)
                
                if error {
                    self?.failedSaveData {
                        self?.internalSaveData(dataManager)
                    }
                } else {
                    self?.succesSaveData(title: "Data saved")
                }
            }
        } else if self.descriptionTextView.text != self.userDescription {
            dataManager.saveUserData(
            name: nil,
            description: self.descriptionTextView.text,
            oldImage: self.userImage,
            newImage: self.profilePhotoView.image) { [weak self] (response, error) in
                self?.modifyUIForSaveData(true)
                self?.updateDataAfterSave(response: response)
                
                if error {
                    self?.failedSaveData {
                        self?.internalSaveData(dataManager)
                    }
                } else {
                    self?.succesSaveData(title: "Data saved")
                }
            }
        } else {
            dataManager.saveUserData(name: nil, description: nil, oldImage: self.userImage, newImage: self.profilePhotoView.image) { [weak self] (response, error) in
                self?.modifyUIForSaveData(true)
                self?.updateDataAfterSave(response: response)
                
                if error {
                    self?.failedSaveData {
                        self?.internalSaveData(dataManager)
                    }
                } else {
                    self?.succesSaveData(title: "Data saved")
                }
            }
        }
//        else{
//            // что-то поменяли, но в итоге сохранять ничего не надо
//            self.modifyUIForSaveData(true)
//            self.succesSaveData(title: "No changes")
//        }
    }

    private func updateDataAfterSave(response: Response?) {
        if let response = response {
            if !response.nameError {
                self.userName = self.nameTextView.text
            }
            if !response.descriptionError {
                self.userDescription = self.descriptionTextView.text
            }
            if !response.imageError {
                self.userImage = self.profilePhotoView.image
            }
        }
    }

    private func modifyUIForSaveData(_ enabled: Bool) {
        if !enabled {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        self.gcdSaveButton.isEnabled = false
        self.operationSaveButton.isEnabled = false
        self.editButtonForBarButton.isEnabled = enabled
    }

    private func succesSaveData(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.applyTheme()
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }

    private func failedSaveData( completion: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: "Error", message: "Failed to save data", preferredStyle: .alert)
        alertController.applyTheme()
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        let repeatAction = UIAlertAction(title: "Repeat", style: .default) { (_) in
            completion()
        }
        alertController.addAction(repeatAction)
        self.present(alertController, animated: true)
    }
    
    private func setupAvatar(image: UIImage) {
        profilePhotoView.image = image
        defaultPhotoView.backgroundColor = .none
        initialsLabel.isHidden = true

        self.wasChange = true
        self.gcdSaveButton.isEnabled = self.wasChange
        self.operationSaveButton.isEnabled = self.wasChange
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        setupAvatar(image: image)
        dismiss(animated: true)
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.wasChange = true
        self.gcdSaveButton.isEnabled = self.wasChange
        self.operationSaveButton.isEnabled = self.wasChange
    }
}

extension ProfileViewController: AvatarSelectDelegate {
    func setupImage(image: UIImage) {
        setupAvatar(image: image)
    }
}
