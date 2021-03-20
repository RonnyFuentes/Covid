//
//  CountryCell.swift
//  CovidStats
//

import SwiftUI

struct CountryCell: View {
	let countryStats: CountryStats

	var body: some View {
		HStack {
			Text(countryStats.flagEmoji)
				.font(.largeTitle)

			VStack(alignment: .leading) {
				Text(countryStats.countryName!)
					.font(.body)

				Text("Total cases: \(countryStats.totalCasesConfirmed)")
					.font(.caption)
					.padding(.top, 4)
			}
		}
	}
}

struct CountryCell_Previews: PreviewProvider {
    static var previews: some View {
        let country = CountryStats(context: CovidService.shared.viewContext)
        country.countryName = "Afghanistan"
        country.countryCode = "AF"
        country.newCasesConfirmed = 276
        country.totalCasesConfirmed = 30451
        country.newDeaths = 8
        country.totalDeaths = 683
        country.newRecovered = 132
        country.totalRecovered = 10306
        
        /*return List(testData.indices) { index in
            CountryCell(countryStats: country)
        }*/
        return CountryCell(countryStats: country)
    }
}
