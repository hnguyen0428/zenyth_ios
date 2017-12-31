//
//  ImageGalleryController.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit
import Photos
import GoogleMaps

class ImageGalleryController: UIViewController, UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UIScrollViewDelegate {
    
    var imageArray = [UIImage]()
    var requestOptions: PHImageRequestOptions?
    var fetchResult: PHFetchResult<PHAsset>?
    
    var cellSize: CGSize!
    var collectionView: UICollectionView!
    
    var imageCropper: ImageCropper? = nil
    var imageCropperFrame: CGRect!
    
    var pickedImages: [Int] = [Int]()
    
    static let SPACE_BETWEEN_CELLS: CGFloat = 1.0
    static let NUM_OF_COLUMNS: Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageCropperWidth = self.view.frame.width
        let imageCropperHeight = imageCropperWidth
        let imageCropperY = self.navigationController!.navigationBar.frame.maxY
        imageCropperFrame = CGRect(x: 0, y: imageCropperY,
                                   width: imageCropperWidth, height: imageCropperHeight)
        
        let cellSize = calculateCellSize()
        grabPhotos(side: cellSize.width)
        self.cellSize = cellSize
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = ImageGalleryController.SPACE_BETWEEN_CELLS
        layout.minimumInteritemSpacing = ImageGalleryController.SPACE_BETWEEN_CELLS
        layout.itemSize = cellSize
        collectionView = UICollectionView(frame: self.view.frame,
                                              collectionViewLayout: layout)
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        collectionView.layoutIfNeeded()
        collectionView.allowsMultipleSelection = false
        view.addSubview(collectionView)
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let nextButton = UIBarButtonItem(title: "Pin!", style: .done,
                                         target: self,
                                         action: #selector(createPinpost))
        self.navigationItem.rightBarButtonItem = nextButton
    }
    
    func grabPhotos(side: CGFloat) {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        self.requestOptions = requestOptions
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                        ascending: true)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image,
                                                             options: fetchOptions)
        self.fetchResult = fetchResult
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i),
                                        targetSize: CGSize(width: side, height: side),
                                        contentMode: PHImageContentMode.aspectFill,
                                        options: requestOptions,
                                        resultHandler:
                    { (image, error) in
                        self.imageArray.append(image!)
                })
            }
        }
    }
    
    func calculateCellSize() -> CGSize {
        let width = view.frame.width
        let numColumns = CGFloat(ImageGalleryController.NUM_OF_COLUMNS)
        let space = ImageGalleryController.SPACE_BETWEEN_CELLS
        let totalSpace = (numColumns - 1) * space
        
        let side = (width - totalSpace) / numColumns
        return CGSize(width: side, height: side)
    }
    
    func createPinpost() {
        let croppedImage = (self.imageCropper?.cropImage())!
        
        let imgManager = PHImageManager.default()
        if let i = pickedImages.first {
            imgManager.requestImage(for: fetchResult!.object(at: i),
                                    targetSize: PHImageManagerMaximumSize,
                                    contentMode: PHImageContentMode.aspectFill,
                                    options: requestOptions,
                                    resultHandler:
                { (image, error) in
                    let originalImage = image!
                    let oImageData = UIImageJPEGRepresentation(originalImage, 0.5)
                    let cImageData = UIImageJPEGRepresentation(croppedImage, 0.5)
                    let title = PinpostForm.shared.title
                    let description = PinpostForm.shared.description
                    var coordinate: CLLocationCoordinate2D!
                    if PinpostForm.shared.usePressedCoordinate {
                        coordinate = PinpostForm.shared.pressedCoordinate
                    }
                    else {
                        coordinate = PinpostForm.shared.coordinate
                    }
                    let lat = coordinate.latitude
                    let lng = coordinate.longitude
                    let privacy = PinpostForm.shared.privacy
                    
                    PinpostManager().createPinpost(withTitle: title,
                                                   description: description,
                                                   latitude: lat,
                                                   longitude: lng,
                                                   privacy: privacy,
                                                   onSuccess:
                        { pinpost in
                            PinpostManager().uploadImage(toPinpostId: pinpost.id,
                                                         imageData: oImageData!,
                                                         thumbnailData: cImageData!)
                            self.transitionToFeed()
                    })
                    
            })
        }
    }
    
    func slideDownCropper() {
        if let cropper = self.imageCropper {
            self.view.addSubview(cropper)
            let frame = cropper.frame
            let newOrigin = CGPoint(x: frame.origin.x, y: frame.origin.y - frame.height)
            cropper.frame = CGRect(origin: newOrigin, size: frame.size)
            
            let newYForCV = collectionView.frame.origin.y + frame.height
            let newHeightForCV = collectionView.frame.height - frame.height
            let cvFrame = collectionView.frame
            let newFrameForCV = CGRect(x: cvFrame.origin.x, y: newYForCV,
                                       width: cvFrame.width, height: newHeightForCV)
            
            UIView.animate(withDuration: 0.3, animations:
                { action in
                    cropper.frame.origin.y = self.imageCropperFrame.origin.y
                    self.collectionView.frame.origin.y = newYForCV
            }, completion:
                { action in
                    self.collectionView.frame = newFrameForCV
            })
        }
    }
    
    func transitionToFeed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let controller = UINavigationController(rootViewController: FeedController())
        NavigationStacks.shared.feedNC = controller
        UIView.animate(withDuration: 0.5, animations:
            { animation in
                appDelegate.window!.rootViewController = controller
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath)
        
        let imageCell = cell as! ImageCell
        imageCell.imageView?.frame = imageCell.bounds
        imageCell.setImage(image: imageArray[indexPath.row])
        
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
        self.pickedImages.append(indexPath.row)
        let imgManager = PHImageManager.default()
        imgManager.requestImage(for: fetchResult!.object(at: indexPath.row),
                                targetSize: PHImageManagerMaximumSize,
                                contentMode: PHImageContentMode.aspectFill,
                                options: requestOptions,
                                resultHandler:
            { (image, error) in
                // Remove the last ImageCropper if there was one
                var shouldSlideDown: Bool = false
                if self.imageCropper != nil {
                    self.imageCropper?.removeFromSuperview()
                    self.imageCropper = nil
                } else {
                    shouldSlideDown = true
                }
                
                self.imageCropper = ImageCropper(frame: self.imageCropperFrame, image: image!)
                self.imageCropper?.delegate = self
                if shouldSlideDown {
                    self.slideDownCropper()
                }
                else {
                    self.view.addSubview(self.imageCropper!)
                }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
        if let index = pickedImages.index(of: indexPath.row) {
            self.pickedImages.remove(at: index)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageCropper?.imageView
    }
    
}
