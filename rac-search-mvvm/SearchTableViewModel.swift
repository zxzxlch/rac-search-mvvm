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
            .flatMap(.latest) { query -> SignalProducer<[String], NoError> in
                guard let query = query else {
                    return SignalProducer(value: [])
                }
                
                let searchResultsProducer = SignalProducer<[String], AnyError> { observer, lifetime in
                    // Start new search request
                    let request = MKLocalSearchRequest()
                    request.naturalLanguageQuery = query
                    let search = MKLocalSearch(request: request)
                    
                    search.start { response, error in
                        guard let response = response else {
                            // Send error
                            let defaultError = NSError(domain: "com.example.rac-search-mvvm", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to complete search request"])
                            observer.send(error: AnyError(error ?? defaultError))
                            return
                        }
                        
                        // Send place names in search results
                        let results: [String] = response.mapItems.map { $0.name ?? "[Unknown]" }
                        observer.send(value: results)
                        observer.sendCompleted()
                    }
                    
                    // Cancel ongoing search if replaced by new search
                    lifetime.observeEnded {
                        guard search.isSearching else { return }
                        print("Previous search canceled: \(query)")
                        search.cancel()
                    }
                }
                
                // Catch any error so that stream will not terminate
                return searchResultsProducer.flatMapError { error -> SignalProducer<[String], NoError> in
                    // Output error
                    print(error)
                    
                    // Replace error with an error message
                    return SignalProducer(value: ["Unable to search. Please try again."])
                }
            }
        
        sectionsProperty <~ searchResultsSignal.map { [$0] }
    }
    
    func cellData(for indexPath: IndexPath) -> String {
        return sections[indexPath.section][indexPath.row]
    }
    
}
