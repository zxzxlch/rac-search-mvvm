//
//  SearchTableViewModel.swift
//  rac-search-mvvm
//
//  Created by Benjamin C on 29/8/17.
//
//

import UIKit
import MapKit
import ReactiveCocoa
import ReactiveSwift
import Result

class SearchTableViewModel {
    private let sectionsProperty = MutableProperty<[[String]]>([])
    
    var sections: [[String]] {
        return sectionsProperty.value
    }
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        sectionsProperty <~ SignalProducer<[[String]], NoError>(value: [["One", "Two", "Three"]])
    }
    
    func cellData(for indexPath: IndexPath) -> String {
        return sections[indexPath.section][indexPath.row]
    }
    
}
