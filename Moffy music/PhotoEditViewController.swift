//
//  PhotoEditViewController.swift
//  Moffy music
//
//  Created by Koki Kurokawa on 2021/07/10.
//

import UIKit

class PhotoEditViewController: UIViewController {
    var sat = ""
    var bri = ""
    var gray2Img: UIImage!
    
    @IBOutlet weak var satLabel: UILabel!
    @IBOutlet weak var briLabel: UILabel!
    @IBOutlet weak var grayImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        satLabel.text = self.sat
        briLabel.text = self.bri
        grayImg.image = self.gray2Img
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
