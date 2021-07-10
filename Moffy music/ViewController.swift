//
//  ViewController.swift
//  Moffy music
//
//  Created by Koki Kurokawa on 2021/07/10.
//

import UIKit
import Photos
import ChameleonFramework

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoPreview: UIImageView!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    var hue : CGFloat = 0.1
    var sat : CGFloat = 0.1
    var bri : CGFloat = 0.1
    var alp : CGFloat = 0.1
    
    var imagePickerController = UIImagePickerController()
    var averageColor: UIColor!
    
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
            let satString = sat.description
            let briString = bri.description
            nextView.sat = satString
            nextView.bri = briString
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

