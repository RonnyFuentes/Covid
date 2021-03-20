//
//  CountryStatsViewModel.swift
//  CovidStats
//
import Combine
import CoreData
import Foundation


class CountryStatsViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
	
    func loadCountryStats() {
        loadSubscription = CovidService.shared.loadCountryStats()
            .sink(receiveCompletion: { result in
                print("Publisher finished with result: \(result)")
            }, receiveValue: {
        })
        
    }
    
    func cancelCall() {
        loadSubscription?.cancel()
        loadSubscription = nil
    }
    
	// MARK: Properties (Published)
	//@Published var countryStats: Array<CountryStatsStruct>
    
    var showWatchedOnly: Bool = false {
        willSet {
            objectWillChange.send()

            countryStatsResultsController = CovidService.shared.fetchCountryStats(watchedOnly: newValue, with: self)
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
    // MARK: Initializer
    override init() {
        super.init()
        
        countryStatsResultsController = CovidService.shared.fetchCountryStats(watchedOnly: showWatchedOnly, with: self)
    }
    // MARK: Properties (Computed)
    var countryStatsList: Array<CountryStats> {
        return countryStatsResultsController?.fetchedObjects ?? []
    }
    
    private var loadSubscription: AnyCancellable?
    private var countryStatsResultsController: NSFetchedResultsController<CountryStats>?
}
