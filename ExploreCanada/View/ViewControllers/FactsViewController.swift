//
//  FactsViewController.swift
//  ExploreCanada
//
//  Created by Prashant on 15/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController {
    private var tableView : FactsTableView!
    private var listViewModel:FactListViewModel? = nil
    
    //MARK:  Controller Life cycle Methods
    override func loadView() {
        super.loadView()
        self.view.backgroundColor =  .white
        self.configureTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listViewModel = FactListViewModel(service: FactService(request: RequestBuilder.getFacts))
        self.fetchFacts()
        self.networkStatus()
    }
    
    private func networkStatus(){
        NetworkManager.shared.start()
        NetworkManager.shared.statusChanged { [weak self] reachability in
            let status = reachability.connection
            switch status {
            case .unavailable, .none:
                print("The network is not reachable")
                self?.showErrorAlert(NetworkError.reachability)
            default: print("")
            }
        }
    }
    
    //MARK:  Helper Methods
    private func configureTableView() {
        self.tableView = FactsTableView(frame: view.bounds, style: .plain)
        self.view.addSubview(tableView)
        self.tableView.addConstraints(with: view, safeAreaGuide: [.top])
        //Register TableViewCell
        self.tableView.register(FactCell.self, forCellReuseIdentifier: FactCell.identifier)
        self.tableView.dataSource = self
        tableView.refreshHandler = {  [unowned self] in
             //Delay of 1 secconds is added because network api call is too fast and user is not able to see the 'refreshing...' title while pull to refresh
             self.title = "Refreshing ..."
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
                self.fetchFacts()
             }
        }
    }
   
    private func fetchFacts(){
        listViewModel?.fetchList { [unowned self] result in
            switch result {
            case .success(let title): self.title = title as? String
                  self.tableView.reloadData()
            case .failure(let error): self.showErrorAlert(error)
            }
            self.title = self.listViewModel?.title
            self.tableView.endRefreshing()
        }
    }
    
    private func showErrorAlert(_ error:Error){
        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension FactsViewController: UITableViewDataSource {
    //Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factCell = tableView.dequeueReusableCell(withIdentifier:  FactCell.identifier, for: indexPath) as! FactCell
        factCell.configure(with: listViewModel?[indexPath.row])
        return factCell
    }
}

