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
    @IBOutlet weak var photoPreview: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
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
    
    //tamura
    var kmax:Int!
    
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
            let latitudeString = self.latitude.description
            let longitudeString = self.longitude.description
            
            nextView.arousal = arousalString
            nextView.valence = valenceString
            nextView.latitude = latitudeString
            nextView.longitude = longitudeString
            nextView.time = self.shootingDate
        }
    }
    

    @IBAction func tappedCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    @IBAction func tppedLibraryButton(_ sender: Any) {
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
    
    func grayscale(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectNoir") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .photoLibrary {
            photoPreview?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        else {
            photoPreview?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        guard let img = photoPreview.image else {return}

        let assetUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
        // PHAsset = Photo Library上の画像、ビデオ、ライブフォト用の型
        let result = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
        
        let asset = result.firstObject
        
        // コンテンツ編集セッションを開始するためのアセットの要求
        asset?.requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
            // contentEditingInput = 編集用のアセットに関する情報を提供するコンテナ
            let url = contentEditingInput?.fullSizeImageURL
            // 対象アセットのURLからCIImageを生成
            let inputImage = CIImage(contentsOf: url!)!
            
            // CIImageのpropertiesから画像のメタデータを取得する
            if inputImage.properties["{GPS}"] as? Dictionary<String,Any> == nil {
                // GPS 情報の取得に失敗した時の処理
                print("GPS Faild")
            } else {
                // GPS 情報の取得に成功した時の処理
                let gps = inputImage.properties["{GPS}"] as? Dictionary<String,Any>
                self.latitude = gps!["Latitude"] as? Double
                let latitudeRef = gps!["LatitudeRef"] as! String
                self.longitude = gps!["Longitude"] as? Double
                let longitudeRef = gps!["LongitudeRef"] as! String
                if latitudeRef == "S" {
                    self.latitude = self.latitude * -1
                }
                if longitudeRef == "W" {
                    self.longitude = self.longitude * -1
                }
                 
            }
            if inputImage.properties["{Exif}"] as? Dictionary<String,Any> == nil {
                print("Exif Failed")
            } else {
                let exif = inputImage.properties["{Exif}"] as? Dictionary<String,Any>
                self.shootingDate = exif!["DateTimeOriginal"] as? String
            }
        })
        
        let averageColor = UIColor(averageColorFrom: img)
        averageColor.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)
        
        picker.dismiss(animated: true, completion: nil)
    }

}

