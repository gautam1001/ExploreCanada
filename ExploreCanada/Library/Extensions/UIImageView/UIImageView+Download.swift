//
//  UIImageView+Download.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        image = nil
        
        if let cachedImage = ImageDownloader.imageCache.object(forKey: urlString as AnyObject) {
            image = cachedImage as? UIImage
            return
        }
        self.image = UIImage(named: "image-preview") //Preview Image
        ImageDownloader.downloadImage(url: url) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let data):
                guard let newImage = UIImage(data: data) else { return }
                ImageDownloader.imageCache.setObject(newImage, forKey: urlString as AnyObject) // Save image to cache
                weakSelf.image = UIImage(data: data)
            case .failure(_):
                DispatchQueue.main.async() {
                    weakSelf.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
                }
            }
        }
    }

}
