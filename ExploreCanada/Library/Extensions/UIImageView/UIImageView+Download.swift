//
//  UIImageView+Download.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import UIKit

extension UIImageView{
    func setImageFromUrl(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil//image-preview
        
        if let cacheImage = imageCache.object(forKey: urlSting as AnyObject) {
            image = cacheImage as? UIImage
            return
        }
        self.image = UIImage(named: "image-preview")
        ImageDownloader.downloadImage(url: url) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                weakSelf.image = UIImage(data: data)
            case .failure(_):
                DispatchQueue.main.async() {
                   weakSelf.backgroundColor = UIColor.lightGray
                    weakSelf.image = UIImage(named: "noimage")
                }
            }
            
        }
        
    }

}
