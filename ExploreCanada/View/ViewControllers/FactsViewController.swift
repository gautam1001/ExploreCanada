//
//  FactsViewController.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController {
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(FactsViewController.refreshAction(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    let factListViewModel = FactListViewModel()
    
    //MARK:  Controller Life cycle Methods
    override func loadView() {
        super.loadView()
        self.view.backgroundColor =  .white
        self.safeArea = view.layoutMarginsGuide
        self.configureTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        factListViewModel.fetchFacts()
        factListViewModel.listUpdated { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        self.view.addSubview(tableView)
          //Add Top,Leading,Bottom,Trailing Constraint to Safe Area
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //View added in the bottom to avoid showing empty space with extra cells ...
        self.tableView.tableFooterView = UIView()
        
        //Register TableViewCell
        self.tableView.register(FactCell.self, forCellReuseIdentifier: FactCell.identifier)
        
        //Set dynamic height of TableViewCell ...
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        //Pull To Refresh control ...
        self.tableView.addSubview(self.refreshControl)
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       }
    
    @objc func refreshAction(_ sender: Any?) {
        self.title = "Refreshing ..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.refreshControl.endRefreshing()
            self.title = "About Canada"
        })
    }
}

extension FactsViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factListViewModel.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factCell = tableView.dequeueReusableCell(withIdentifier:  FactCell.identifier, for: indexPath) as! FactCell
        factCell.configure(with: factListViewModel[indexPath.row])
        return factCell
    }
}

