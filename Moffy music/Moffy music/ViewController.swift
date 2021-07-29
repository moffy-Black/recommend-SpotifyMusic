//
//  ViewController.swift
//  Moffy music
//
//  Created by Koki Kurokawa on 2021/07/28.
//

import UIKit
import Photos
import ChameleonFramework
import Matft

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIView connected values
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoPreview: UIImageView!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    // hsba values
    var hue : CGFloat = 0.1
    var sat : CGFloat = 0.1
    var bri : CGFloat = 0.1
    var alp : CGFloat = 0.1
    
    // exchange to gray values
    let redCoefficient: Float = 0.2126
    let greenCoefficient: Float = 0.7152
    let blueCoefficient: Float = 0.0722
    
    // camera & photo library function's values
    var imagePickerController = UIImagePickerController()
    var averageColor: UIColor!
    
    // Exif information
    var latitude: Double!
    var longitude: Double!
    
    // times
    var shootingDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
        checkPermissions()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoEditViewController" {
            let nextView = segue.destination as! PhotoEditViewController
//            nextView.hue = self.hue
            let arousal = (-0.31 * self.bri) + (0.6 * self.sat)
            let valence = (0.69 * self.bri) + (0.22 * self.sat)
            let arousalString = arousal.description
            let valenceString = valence.description
//            let latitudeString = self.latitude.description
//            let longitudeString = self.longitude.description
            
            nextView.arousal = arousalString
            nextView.valence = valenceString
//            nextView.latitude = latitudeString
//            nextView.longitude = longitudeString
//            nextView.time = shootingDate
        }
    }
    
    @IBAction func tappedCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func tappedLibraryButton(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
            })
        }

        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        } else {
            PHPhotoLibrary
                .requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Access granted to use Photo Library")
        } else {
            print("We don't have access to your Photos.")
        }
    }
    
    func getPixels(image: UIImage) -> (imgDataArray:MfArray,h:Int,w:Int) {
        guard let cgImage = image.cgImage,
            let data = cgImage.dataProvider?.data,
            let bytes = CFDataGetBytePtr(data) else {
            fatalError("Couldn't access image data")
        }
        assert(cgImage.colorSpace?.model == .rgb)
        
        let imgDataArray = Matft.nums(0, shape: [cgImage.height, cgImage.width])
        
        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        for y in 0 ..< cgImage.height {
            for x in 0 ..< cgImage.width {
                let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                let r = bytes[offset]
                let g = bytes[offset + 1]
                let b = bytes[offset + 2]
                let grayLevel = (Float(r) * redCoefficient) + (Float(g) * greenCoefficient) + (Float(b) * blueCoefficient)
                imgDataArray[y][x] = grayLevel
            }
        }
        return (imgDataArray, cgImage.height, cgImage.width)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .photoLibrary {
            photoPreview?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        else {
            photoPreview?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        guard let img = photoPreview.image else {return}
        
        
        let averageColor = UIColor(averageColorFrom: img)
        averageColor.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)
        
        picker.dismiss(animated: true, completion: nil)
    }

}



