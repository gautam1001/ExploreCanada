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
       - Represented by its name
     */
    static var identifier: String {
        return String(describing: self)
    }
}
class FactCell: UITableViewCell {
    private let factImageView:UIImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    // Must be provided if overriding a designated initializer..
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }
    
    
    
    private func setupUI(){
         self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //Add ImageView and labels to contentView
        self.contentView.addSubview(factImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        
        factImageView.circleShaped()
        titleLabel.configure(fontSize: 20, numberOfLines: 1)
        descriptionLabel.configure(fontSize: 14, numberOfLines: 0)
        
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        //ImageView Constraints
        self.factImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        self.factImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        self.factImageView.widthAnchor.constraint(equalToConstant:80).isActive = true
        self.factImageView.heightAnchor.constraint(equalToConstant:80).isActive = true
        self.factImageView.bottomAnchor.constraint(lessThanOrEqualTo:self.contentView.bottomAnchor, constant:-10).isActive = true
        
        //TitleLabel Constraints
        self.titleLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor,constant: 10).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo:self.factImageView.trailingAnchor,constant: 10).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor,constant: -10).isActive = true
        
        //DescriptionLabel Constraints
        self.descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor,constant: 4).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo:self.titleLabel.leadingAnchor).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo:self.titleLabel.trailingAnchor).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor,constant: -10).isActive = true
        
    }
    
    func configure(with viewModel:FactViewModel?){
        if let imageHref = viewModel?.imageHref {
            self.factImageView.setImage(with: imageHref)
        }
        self.titleLabel.text = viewModel?.title
        self.descriptionLabel.text = viewModel?.description
    }


}
