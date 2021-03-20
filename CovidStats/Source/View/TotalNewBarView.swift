//
//  TwoValueBarGraph.swift
//  CovidStats
//

import SwiftUI

struct TwoValueBarGraph: View {
	let maximumValue: Int
	let totalCount: Int
	let newCount: Int
	let color: Color

	var body: some View {
		Group {
			GeometryReader { geometryProxy in
				HStack(spacing: 0) {
					HStack(spacing: 0) {
						Rectangle()
							.fill(self.color)
							.frame(width: (geometryProxy.size.width * 0.9) * ((CGFloat(self.totalCount) - CGFloat(self.newCount)) / CGFloat(self.maximumValue)), height: 50)

						Rectangle()
							.fill(self.color)
							.brightness(0.25)
							.frame(width: (geometryProxy.size.width * 0.9) * (CGFloat(self.newCount) / CGFloat(self.maximumValue)), height: 50)
					}.clipShape(RightRoundedRectangle(cornerRadius: 16))

					Spacer(minLength: 0)
				}
			}
		}
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
		TwoValueBarGraph(maximumValue: 100, totalCount: 100, newCount: 2, color: Color.red)
    }
}
