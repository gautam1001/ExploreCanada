//
//  FactsTableView.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import UIKit

class FactsTableView: UITableView {
    
    lazy var _refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshAction(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    var refreshHandler: (()->Void)?
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        //View added in the bottom to avoid showing empty space with extra cells ...
        tableFooterView = UIView()
        //Set dynamic height of TableViewCell ...
        estimatedRowHeight = 80
        rowHeight = UITableView.automaticDimension
        //dataSource = self
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        showsVerticalScrollIndicator = false
        refreshControl = _refreshControl
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func refreshAction(_ sender: Any?) {
       self.refreshHandler?()
    }
    
    func endRefreshing() {
        _refreshControl.endRefreshing()
    }
}
