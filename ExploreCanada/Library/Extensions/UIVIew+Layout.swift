//
//  UIVIew+Layout.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//
import Foundation
import UIKit
enum SafeAreaGuide {
    case top
    case bottom
    case left
    case right
}

struct AutoLayoutConstant {
    var top:CGFloat = 0
    var bottom:CGFloat = 0
    var left:CGFloat = 0
    var right:CGFloat = 0
}

extension UIView {
    
    func addConstraints(with view:UIView, constants:AutoLayoutConstant = AutoLayoutConstant(top: 0, bottom: 0, left: 0, right: 0), safeAreaGuide: [SafeAreaGuide] = []) {
        let safeArea = view.layoutMarginsGuide
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: safeAreaGuide.contains(.left) ? safeArea.leftAnchor : view.leftAnchor,constant: constants.left).isActive = true
        rightAnchor.constraint(equalTo: safeAreaGuide.contains(.right)  ? safeArea.rightAnchor : view.rightAnchor,constant: constants.right).isActive = true
        topAnchor.constraint(equalTo: safeAreaGuide.contains(.top)  ? safeArea.topAnchor : view.topAnchor,constant: constants.top).isActive = true
        bottomAnchor.constraint(equalTo: safeAreaGuide.contains(.bottom)  ? safeArea.bottomAnchor : view.bottomAnchor,constant: constants.bottom).isActive = true
    }
}
