//
//  FactCell.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import UIKit
extension UITableViewCell {
    /** Cell Identifier
       Must be represented by its name
     */
    static var identifier: String {
        return String(describing: self)
    }
}
class FactCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }


}
