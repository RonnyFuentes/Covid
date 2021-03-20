//
//  CountryStats+CoreDataProperties.swift
//  CovidStats
//
//  Created by Ronny Fuentes  on 7/3/20.
//  Copyright © 2020 CIS 399. All rights reserved.
//
//

import Foundation
import CoreData


class CountryStats: NSManagedObject {
@nonobjc public class func fetchRequest() -> NSFetchRequest<CountryStats> {
    return NSFetchRequest<CountryStats>(entityName: "CountryStats")
}

    @NSManaged public var countryName: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var newCasesConfirmed: Int64
    @NSManaged public var totalCasesConfirmed: Int64
    @NSManaged public var newDeaths: Int64
    @NSManaged public var totalDeaths: Int64
    @NSManaged public var newRecovered: Int64
    @NSManaged public var totalRecovered: Int64
    @NSManaged public var isWatched: Bool
    
    var flagEmoji: String {
        guard Locale.isoRegionCodes.contains(countryCode!) else {
            return ""
        }

        var flagString = ""
        for s in countryCode!.unicodeScalars {
            guard let scalar = UnicodeScalar(127397 + s.value) else {
                continue
            }

            flagString.append(String(scalar))
        }

        return flagString
    }

}
