//
//  GalleryView.swift
//  Roots_02
//
//  Created by David Utt on 4/8/17.
//  Copyright © 2017 David Utt. All rights reserved.
//

import UIKit
import Photos


class GalleryView: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        collectPhotos()
    }
    
    func collectPhotos(){
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
//      fetch by date
        //fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        // fetch by album name
        fetchOptions.predicate = NSPredicate(format: "localIdentifier = %@", "Roots")
        
        if let fetchResults : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions){
            
            if fetchResults.count > 0{
                for i in 0..<fetchResults.count{
                    imgManager.requestImage(for: fetchResults.object(at: i) as! PHAsset, targetSize: CGSize(width:200,height:200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        image, error in
                        
                        self.imageArray.append(image!)
                    })
                }
            }
            else{
            print("No Photos Available")
            self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    //adding images to cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        //create cell for image
        imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    //flow layout cptions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width/3
        
        return CGSize(width:width,height:width)
    }
    
    
    @IBAction func dismissGallery(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    
    

}


