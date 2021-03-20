//
//  RightRoundedRectangle.swift
//  CovidStats
//

import SwiftUI

struct RightRoundedRectangle: Shape {
	let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}
