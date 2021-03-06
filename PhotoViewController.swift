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
        timer?.invalidate()
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        self.EndTime()
        let imageData = UIImageJPEGRepresentation(imageView!.image!, 0.8)
        let compressedJPEGImage = UIImage(data: imageData!)
            compressedJPEGImage?.accessibilityIdentifier = timerArray[timerArray.count-1]
        
        
        //save image to album
        //UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        //print("\(String(describing: compressedJPEGImage!.accessibilityIdentifier))")
       
        CustomPhotoAlbum.sharedInstance.save(image: compressedJPEGImage!)
        
        saveNotice()
    }
    
    func saveNotice(){
        let alertController = UIAlertController(title: "👏🏻 That's A Keeper 👏🏻", message: "I couldn't have taken a better photo", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            self.present(self.PlanterVC, animated: true, completion: nil)
        })
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion:nil)
        
    }
    
    func EndTime() {
        timer?.invalidate()
        print("You Spent ", count, " seconds taking that picture")
        timerArray.append(count)
        print(timerArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//References
    //AVfoundation Camera Fundamentals
        //https://www.youtube.com/watch?v=jJRNoLfoVHU
        //https://www.youtube.com/watch?v=Zv4cJf5qdu0
        //https://www.youtube.com/watch?v=yW-6bxk3j2g
