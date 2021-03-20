//
//  CountryDetail.swift
//  CovidStats
//

import SwiftUI

struct CountryDetail: View {
	@ObservedObject var countryStats: CountryStats

    var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				HStack {
					Spacer()

					Text(self.countryStats.flagEmoji)
						.font(Font.system(size: 100))

					Spacer()
				}

				TwoValueBarGraph(maximumValue: countryStats.totalCasesConfirmed, totalCount: countryStats.totalCasesConfirmed, newCount: countryStats.newCasesConfirmed, color: .purple)
					.frame(height: 50)

				Text("Total Confirmed Cases: \(self.countryStats.totalCasesConfirmed)")
					.font(.caption)
					.padding(.leading, 8)
					.padding(.bottom, 32)

				TwoValueBarGraph(maximumValue: countryStats.totalCasesConfirmed, totalCount: countryStats.totalRecovered, newCount: countryStats.newRecovered, color: .green)
					.frame(height: 50)
 
				Text("Total Recovered: \(self.countryStats.totalRecovered)")
					.font(.caption)
					.padding(.leading, 8)
					.padding(.bottom, 32)

				TwoValueBarGraph(maximumValue: countryStats.totalCasesConfirmed, totalCount: countryStats.totalDeaths, newCount: countryStats.newDeaths, color: .red)
					.frame(height: 50)

				Text("Total Deaths: \(self.countryStats.totalDeaths)")
					.padding(.leading, 8)
					.font(.caption)
			}
		}
		.navigationBarTitle(countryStats.countryName!)
		.navigationBarItems(trailing: Button(action: {
			self.countryStats.isWatched.toggle()
		}, label: {
			Image(systemName: countryStats.isWatched ? "eye" : "eye.slash")
		}))
	}
}

struct CountryDetail_Previews: PreviewProvider {
	// @State static var countryStats = testData[177]

    static var previews: some View {
        
        let context = CovidService.shared.viewContext
        let country = CountryStats(context: context)
        
        country.countryName = "Afghanistan"
        country.countryCode = "AF"
        country.newCasesConfirmed = 276
        country.totalCasesConfirmed = 30451
        country.newDeaths = 8
        country.totalDeaths = 683
        country.newRecovered = 132
        country.totalRecovered = 10306
        
        return CountryDetail(countryStats: country)
    }
}
