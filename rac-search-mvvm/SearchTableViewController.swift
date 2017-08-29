//
//  SearchTableViewController.swift
//  learn-reactivecocoa
//
//  Created by Benjamin C on 29/8/17.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class SearchTableViewController: UITableViewController {
    private let viewModel = SearchTableViewModel()
    
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
    
    private func setupBindings() {
        viewModel.searchQueryProperty <~ searchBar.reactive.continuousTextValues
        
        // Reload with updated results
        viewModel.sectionsSignal.observeValues { [unowned self] _ in
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = viewModel.cellData(for: indexPath)
        
        return cell
    }
    
}
