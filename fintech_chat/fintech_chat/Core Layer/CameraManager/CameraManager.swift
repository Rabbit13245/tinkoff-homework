import UIKit
import AVFoundation

class CameraManager: ICameraManager {
    func checkCameraPermission() -> Bool {
        guard UIImagePickerController.isCameraDeviceAvailable(.rear) || UIImagePickerController.isCameraDeviceAvailable(.front) else {
            return false
        }
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraStatus {
        case .denied, .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            var res = false
            let sem = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                res = success
                sem.signal()
            }
            sem.wait()
            return res
        @unknown default:
            return false
        }
    }
    
    func cameraSettings() -> UIAlertController {
        let ac = UIAlertController(title: "Error", message: "Camera access is denied", preferredStyle: .alert)
        ac.applyTheme()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Settings", style: .default) {(_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        
        return ac
    }
}
