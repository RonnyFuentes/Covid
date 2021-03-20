//
//  CountryStats+CoreDataClass.swift
//  CovidStats
//
//  Created by Ronny Fuentes  on 7/3/20.
//  Copyright © 2020 CIS 399. All rights reserved.
//
//
/*
import Foundation
import CoreData

public class CountryStats: NSManagedObject {
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
*/
