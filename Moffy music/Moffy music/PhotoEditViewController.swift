//
//  PhotoEditViewController.swift
//  Moffy music
//
//  Created by Koki Kurokawa on 2021/07/29.
//

import UIKit

class PhotoEditViewController: UIViewController {
    var arousal = ""
    var valence = ""
    var latitude = ""
    var longitude = ""
    var time = ""

    @IBOutlet weak var arousalLabel: UILabel!
    @IBOutlet weak var valenceLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        arousalLabel.text = self.arousal
        valenceLabel.text = self.valence
        latitudeLabel.text = self.latitude
        longitudeLabel.text = self.longitude
        timeLabel.text = self.time
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
