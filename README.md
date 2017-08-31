# iOS with ReactiveCocoa and MVVM example

Example of how to use ReactiveCocoa and MVVM for an iOS app. Search-as-you-type with throttling.

Dependencies:

- [ReactiveCocoa 6.0.1](https://github.com/ReactiveCocoa/ReactiveCocoa/)
- [ReactiveSwift 2.0.1](https://github.com/ReactiveCocoa/ReactiveSwift/)


## Get Started

1. Clone this repository.
2. Run `carthage update`
 
When you're ready to do this own your own, run `git checkout start-here`.


## How It Works

`SearchTableViewController`:

1. Pass search box updates to the view model with `viewModel.searchQueryProperty <~ searchBar.reactive.continuousTextValues`


`SearchTableViewModel`:

1. Trim search query
2. Throttle signal
3. Start a new search, discard previous requests
4. Update sections data with search results


`SearchTableViewController`:

1. Reload table when sections (from view model) update


## Questions?

Tweet at [@zxzxlch](https://twitter.com/zxzxlch).

