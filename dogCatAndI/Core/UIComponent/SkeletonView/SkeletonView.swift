//
//  SkeletonView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import SwiftUI

struct RoundedRectangleSkeletionView: View {
    private var color: Color
    private var radius: CGFloat

    init(color: Color = Color(DSColor.gray2), radius: CGFloat = 8) {
        self.color = color
        self.radius = radius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(color)
    }
}

struct CircleSkeletionView: View {
    private var color: Color

    init(color: Color = Color(DSColor.gray2)) {
        self.color = color
    }

    var body: some View {
        Circle()
            .fill(color)
    }
}
