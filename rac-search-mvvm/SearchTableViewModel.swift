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
    let searchQueryProperty = MutableProperty<String?>(nil)
    
    var sections: [[String]] {
        return sectionsProperty.value
    }
    
    var sectionsSignal: Signal<[[String]], NoError> {
        return sectionsProperty.signal
    }
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Trim search query
        let parsedQuerySignal: Signal<String?, NoError> = searchQueryProperty.signal.map { value in
            if let trimmed = value?.trimmingCharacters(in: .whitespaces) {
                // Return nil if empty
                return trimmed.isEmpty ? nil : trimmed
            }
            return nil
        }
        
        let searchResultsSignal: Signal<[String], NoError> = parsedQuerySignal
            .throttle(0.3, on: QueueScheduler.main)
            .map { query in
                guard let query = query else {
                    return ["0 results found"]
                }
                return [query]
            }
        
        sectionsProperty <~ searchResultsSignal.map { [$0] }
    }
    
    func cellData(for indexPath: IndexPath) -> String {
        return sections[indexPath.section][indexPath.row]
    }
    
}
