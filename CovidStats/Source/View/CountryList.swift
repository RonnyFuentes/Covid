//
//  CountryList.swift
//  CovidStats
//

import SwiftUI

struct CountryList: View {
	@ObservedObject var countryStatsViewModel: CountryStatsViewModel

    var body: some View {
		NavigationView {
			List {
				Section {
					Toggle("Show Watched Countries", isOn: $countryStatsViewModel.showWatchedOnly)
				}

				Section {
                    ForEach(countryStatsViewModel.countryStatsList, id: \.countryName) { currentCountry in
						NavigationLink(destination: CountryDetail(countryStats: currentCountry)) {
                            CountryCell(countryStats: currentCountry)
						}
					}
				}
			}
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Covid19 Stats")
		}
        .onAppear { self.countryStatsViewModel.loadCountryStats() }
        .onDisappear { self.countryStatsViewModel.cancelCall()}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		CountryList(countryStatsViewModel: CountryStatsViewModel())
    }
}
