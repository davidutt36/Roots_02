//
//  GalleryView.swift
//  Roots_02
//
//  Created by David Utt on 4/8/17.
//  Copyright © 2017 David Utt. All rights reserved.
//

import UIKit
import Photos

var RootsArrary = [UIImage]()

class GalleryView: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    
    override func viewDidLoad() {
        FetchCustomAlbumPhotos()
        print("You Have \(RootsArrary.count) Root Photos")
    }
    
    func FetchCustomAlbumPhotos(){
        var albumName = "Roots"
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var photoAssets = PHFetchResult<AnyObject>()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let first_obj:AnyObject = collection.firstObject{
            //find album
            assetCollection = collection.firstObject as! PHAssetCollection
            albumFound = true
        }
        else{ albumFound = false}
        var i = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        
        photoAssets.enumerateObjects({(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                //print("Inside  If object is image asset, number \(i)")
                let imageSize = CGSize(width: asset.pixelWidth,height: asset.pixelHeight)
                
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isSynchronous = true
                
//                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: {
//                    (image, info) -> Void in
//                    self.photo = image!
//                    /* The image is now available to us */
//                    self.addIma
//                    //self.addImgToArray(self.photo)
//                    print("enum for image, This is number 2")
//                })
                
                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler:
                {
                image, error in
                RootsArrary.append(image!)
                })
            }
        })
    }
    
    //Collection View Creation
    //index path has section paramater and row with each being a layer of the tabelview ->I.S.R
    //required
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RootsArrary.count
    }

    //required
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = RootsArrary[indexPath.row]
        return cell
    }
    
    //collection view styling
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    @IBAction func dismissGallery(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    
}
//References
    //Select a Specsific Gallery
        //http://stackoverflow.com/questions/32752437/swift-select-all-photos-from-specific-photos-album
        //http://stackoverflow.com/questions/32169185/how-to-fetch-all-images-from-custom-photo-album-swift
        //https://codedump.io/share/Vrl4dB3VThIK/1/swift-select-all-photos-from-specific-photos-album
        //https://www.youtube.com/watch?v=BFZ4ZCw_9z4
    //making gallery image clickable
        //https://www.youtube.com/watch?v=R8YH_5l7v1k
