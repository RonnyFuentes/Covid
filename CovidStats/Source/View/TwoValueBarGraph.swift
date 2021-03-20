//
//  TwoValueBarGraph.swift
//  CovidStats
//

import SwiftUI

struct TwoValueBarGraph: View {
	var body: some View {
		Group {
			GeometryReader { geometryProxy in
				HStack(spacing: 0) {
					HStack(spacing: 0) {
						Rectangle()
							.fill(self.color)
							.frame(width: (geometryProxy.size.width * 0.9) * ((self.totalCount - self.newCount) / self.maximumValue), height: 50)

						Rectangle()
							.fill(self.color)
							.brightness(0.25)
							.frame(width: (geometryProxy.size.width * 0.9) * (self.newCount / self.maximumValue), height: 50)
					}.clipShape(RightRoundedRectangle(cornerRadius: 16))

					Spacer(minLength: 0)
				}
			}
		}
    }

	// MARK: Initialization
	init(maximumValue: Int64, totalCount: Int64, newCount: Int64, color: Color) {
		self.maximumValue = CGFloat(maximumValue)
		self.totalCount = CGFloat(totalCount)
		self.newCount = CGFloat(newCount)
		self.color = color
	}

	// MARK: Properties
	let maximumValue: CGFloat
	let totalCount: CGFloat
	let newCount: CGFloat
	let color: Color
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
		TwoValueBarGraph(maximumValue: 100, totalCount: 100, newCount: 2, color: Color.red)
    }
}
