//
//  NetworkManager.swift
//  ExploreCanada
//
//  Created by Prashant Gautam on 26/08/20.
//  Copyright © 2020 Prashant Gautam. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    
    typealias Listener = (Reachability) -> Void
    private var listener:Listener?
    
    let reachability = try? Reachability(hostname: "www.google.com")
    
    func start(){
        reachability?.whenReachable = { [weak self]  reachability in
            self?.listener?(reachability)
        }
        do {
           try  reachability?.startNotifier()
        }catch {
            print(error.localizedDescription)
        }
        
        reachability?.whenUnreachable = { [weak self] reachability in
            self?.listener?(reachability)
        }
    }
    
    func statusChanged(_ listener: @escaping Listener){
        self.listener = listener
    }
    
}
