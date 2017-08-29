//
//  SearchTableViewController.swift
//  learn-reactivecocoa
//
//  Created by Benjamin C on 29/8/17.
//  Copyright © 2017 Benjamin Cheah. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class SearchTableViewController: UITableViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        searchBar.placeholder = "Search places"
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        
        navigationItem.titleView = searchBar
        
        setupBindings()
    }
    
    func setupBindings() {
        
    }
    
}
