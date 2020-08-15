//
//  UIImageView+Layer.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import UIKit

extension UIImageView {
    func circleShaped(){
        self.contentMode = .scaleAspectFill // image content fits in the space best suited for the image and will never be strecthed vertially and horizontally
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false // Enable autolayouts
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
    }
}
