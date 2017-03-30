//
//  PhotoViewController.swift
//  Roots_02
//
//  Created by David Utt on 3/24/17.
//  Copyright © 2017 David Utt. All rights reserved.
//




import UIKit
import Photos

class PhotoViewController: UIViewController {

    //foundation variables
    var takenPhoto: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    let PlanterVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "PlanterVC") 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = takenPhoto {
            imageView.image = availableImage
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(imageView!.image!, 0.8)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        
       // CustomPhotoAlbum.sharedInstance.saveImage(compressedJPEGImage)
        
        saveNotice()
    }
    
    func saveNotice(){
        let alertController = UIAlertController(title: "Image Saved!", message: "Image saved to the main photo libaray", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            self.present(self.PlanterVC, animated: true, completion: nil)
        })
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
