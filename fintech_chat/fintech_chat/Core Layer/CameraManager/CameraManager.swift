import UIKit
import AVFoundation

class CameraManager: CameraManagerProtocol {
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
}
