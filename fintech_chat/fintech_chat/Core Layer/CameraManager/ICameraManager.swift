import UIKit

protocol ICameraManager {
    func checkCameraPermission() -> Bool
    
    func cameraSettings() -> UIAlertController
}
