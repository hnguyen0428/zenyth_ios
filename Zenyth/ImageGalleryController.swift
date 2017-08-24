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

class ImageGalleryController: UIViewController, UICollectionViewDelegate,
                                UICollectionViewDataSource {
    
    var imageArray = [UIImage]()
    var cellSize: CGSize!
    var collectionView: UICollectionView!
    
    static let SPACE_BETWEEN_CELLS: CGFloat = 1.0
    static let NUM_OF_COLUMNS: Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        collectionView.backgroundColor = UIColor.white
        collectionView.layoutIfNeeded()
        view.addSubview(collectionView)
        view.backgroundColor = UIColor.white
    }
    
    func grabPhotos(side: CGFloat) {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                        ascending: true)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image,
                                                             options: fetchOptions)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath)
        
        let imageCell = cell as! ImageCell
        imageCell.imageView.frame = imageCell.bounds
        imageCell.setImage(image: imageArray[indexPath.row])
        
        return imageCell
    }
    
}
