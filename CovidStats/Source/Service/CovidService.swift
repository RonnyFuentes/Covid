//
//  CovidService.swift
//  CovidStats
//

import Combine
import CoreData

class CovidService {
    
    
    // MARK: Load
    func loadCountryStats() -> AnyPublisher<Void, Error> {
        let url = URL(string: "https://api.covid19api.com/summary")
        
            let urlSession = URLSession.shared
        
        // data task publisher? This publisher produces a data xfer object?
        // publisher: sends a series of values (events?)
        
        // Result of publisher: Returns the response (omit) and data, converts it to data, and decodes data into object.
        // producing DTO
        let publisher = urlSession.dataTaskPublisher(for: url!)
            // This will change objects we can use and store them in core data.
            .map { (data, _) -> Data in
                data
            }
            .decode(type: OuterDataTransferObject.self, decoder: jsonDecoder) // binary data
            .flatMap { values -> Empty<Void, Error> in
                // take new value and return empty publisher
                
                self.processCountryStatsDataTransferObjects(dataTransferObjects: values.countries)
                return Empty<Void, Error>(completeImmediately: true)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
        return publisher
        
    }
    
    // MARK: Data Store
    func fetchCountryStats(watchedOnly: Bool, with delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<CountryStats>? {
        // fetch request for CountryStats objects
        let fetchRequest: NSFetchRequest<CountryStats> = CountryStats.fetchRequest()
        
        // for fetching CountryStats that are watched (true)
        if watchedOnly {
            // predicate specifies what/how to search
            fetchRequest.predicate = NSPredicate(format: "isWatched == %@", watchedOnly as NSNumber)
        }

        // how to sort the array of CountryStats objects
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CountryStats.countryName, ascending: true)]
        
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = delegate
        
        let result: NSFetchedResultsController<CountryStats>?
        
        do {
            try resultsController.performFetch()
            result = resultsController
        }
        catch let error {
            print("Error with fetching: \(error)")
            result = nil
        }
        // resultsController essentially the same as returning array of CountryStats objects
        return result
    }
    
    private func fetchCountryStats(withName name: String, in context: NSManagedObjectContext) throws -> CountryStats? {
        let fetchRequest: NSFetchRequest<CountryStats> = CountryStats.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "countryName == %@", name)
        fetchRequest.fetchLimit = 1
        
        return try context.fetch(fetchRequest).first
    }
    
    private func processCountryStatsDataTransferObjects(dataTransferObjects: Array<CountryStatsDataTransferObject>) {
        
        // Bullet 2. Background context
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        context.performAndWait {
            do {
                for data in dataTransferObjects {
                    if let exisitingCountryStats = try self.fetchCountryStats(withName: data.countryName, in: context) {
                        exisitingCountryStats.update(with: data)
                    }
                    else {
                        let _ = CountryStats(context: context, dataTransferObject: data)
                    }
                }
                
                try context.save()
            }
            catch let error {
                print("Issue with saving context: \(error)")
                context.rollback()
            }
        }
    }
    
	// MARK: Initialization
	private init() {
		persistentContainer = NSPersistentContainer(name: "Model")

		persistentContainer.loadPersistentStores { storeDescription, error in
			if let error = error {
				fatalError("Error loading persistent store \(error as NSError)")
			}

			self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
			self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
		}
	}

	// MARK: Properties (Private)
	private let persistentContainer: NSPersistentContainer
    private let jsonDecoder = JSONDecoder()

	// MARK: Properties (Computed)
    #if DEBUG
	var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    #endif
    
	// MARK: Properties (Static)
    // singleton instance?
	static let shared = CovidService()
}

// MARK: Data Transsfer Object

// Convert json data to something easy to work with?


fileprivate struct OuterDataTransferObject: Decodable {
    let countries: Array<CountryStatsDataTransferObject>
    
    private enum CodingKeys: String, CodingKey {
        case countries = "Countries"
    }
}


fileprivate struct CountryStatsDataTransferObject: Decodable {
    let countryName: String
    let countryCode: String
    let newCasesConfirmed: Int64
    let totalCasesConfirmed: Int64
    let newDeaths: Int64
    let totalDeaths: Int64
    let newRecovered: Int64
    let totalRecovered: Int64
    
/*
     @NSManaged public var countryName: String?
     @NSManaged public var countryCode: String?
     @NSManaged public var newCasesConfirmed: Int64
     @NSManaged public var totalCasesConfirmed: Int64
     @NSManaged public var newDeaths: Int64
     @NSManaged public var totalDeaths: Int64
     @NSManaged public var newRecovered: Int64
     @NSManaged public var totalRecovered: Int64
     @NSManaged public var isWatched: Bool
     */
    private enum CodingKeys: String, CodingKey {
        case countryName = "Country"
        case countryCode = "CountryCode"
        case newCasesConfirmed = "NewConfirmed"
        case totalCasesConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
}

fileprivate extension CountryStats {
    convenience init(context: NSManagedObjectContext, dataTransferObject: CountryStatsDataTransferObject) {
        self.init(context: context)
        update(with: dataTransferObject)
    }
    
    func update(with dataTransferObject: CountryStatsDataTransferObject) {
        countryName = dataTransferObject.countryName
        countryCode = dataTransferObject.countryCode
        newCasesConfirmed = dataTransferObject.newCasesConfirmed
        totalCasesConfirmed = dataTransferObject.totalCasesConfirmed
        newDeaths = dataTransferObject.newDeaths
        totalDeaths = dataTransferObject.totalDeaths
        newRecovered = dataTransferObject.newRecovered
        totalRecovered = dataTransferObject.totalRecovered
    }
}
/*
 {"Country":"Afghanistan",
 "CountryCode":"AF",
 "Slug":"afghanistan", (relevant?)
 "NewConfirmed":348,
 "TotalConfirmed":32672,
 "NewDeaths":7,
 "TotalDeaths":826,
 "NewRecovered":1833,
 "TotalRecovered":19164,
 "Date":"2020-07-05T23:29:55Z" (relevant?)
 
 }
 */
