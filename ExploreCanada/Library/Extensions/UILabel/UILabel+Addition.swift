//
//  AppLabel.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// Configure label as per application
    /// - Parameter fontSize: font size
    /// - Parameter numberOfLines: number of lines allowed
    func configure(fontSize: CGFloat = 14,numberOfLines: Int){
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
