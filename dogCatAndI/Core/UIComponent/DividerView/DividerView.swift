//
//  DividerView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 9/2/2569 BE.
//

import SwiftUI

struct HDividerView: View {
    let color: Color
    let height: CGFloat

    init(color: Color = Color(DSColor.black), height: CGFloat = 1) {
        self.color = color
        self.height = height
    }

    var body: some View {
        color
            .frame(height: height)
    }
}
