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
    
    
    // Initial ui setup of the tablevie cell
    private func setupUI(){
        //Add ImageView and labels to contentView
        self.contentView.addSubview(factImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        
        factImageView.circleShaped()
        factImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        titleLabel.configure(fontSize: 20, numberOfLines: 1)
        descriptionLabel.configure(fontSize: 14, numberOfLines: 0)
        self.setUpConstraints()
    }
    
    // Apply autolayouts
    private func setUpConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        //ImageView Constraints
        self.factImageView.widthAnchor.constraint(equalToConstant:80).isActive = true
        self.factImageView.heightAnchor.constraint(equalToConstant:80).isActive = true
        self.factImageView.topAnchor.constraint(greaterThanOrEqualTo:self.contentView.topAnchor, constant:10).isActive = true
        self.factImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        self.contentView.bottomAnchor.constraint(greaterThanOrEqualTo:self.factImageView.bottomAnchor, constant:10).isActive = true
        self.factImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        
        //TitleLabel Constraints
        self.titleLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor,constant: 10).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo:self.factImageView.trailingAnchor,constant: 10).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor,constant: -10).isActive = true
        self.titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        //DescriptionLabel Constraints
        self.descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor,constant: 5).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo:self.titleLabel.leadingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(greaterThanOrEqualTo: self.descriptionLabel.bottomAnchor, constant: 10).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo:self.descriptionLabel.trailingAnchor, constant: 10).isActive = true
    }
    
    
    // Configure cell UI with the fact data
    func configure(with viewModel:FactViewModel?){
        if let imageHref = viewModel?.imageHref {
            self.factImageView.setImage(with: imageHref)
        }
        self.titleLabel.text = viewModel?.title
        self.descriptionLabel.text = viewModel?.description
    }
    
    
}
