//
//  NavigationBarView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import SwiftUI
import UIKit

struct CustomNavBarView<Leading, Trailing>: View where Leading: View, Trailing: View {
    // MARK: - Property
    private let title: String
    private var hasBackButton: Bool
    private let barHeight: CGFloat
    private let bgColor: [Color]
    @ViewBuilder private let leadingView: () -> Leading
    @ViewBuilder private let trailingView: () -> Trailing

    @Environment(\.dismiss) var dismiss

    private let isPhone = UIDevice.isPhone

    // MARK: - Text Style
    private let titleTextStyle: TextStyler

    // MARK: - Init
    init(
        title: String,
        titleFont: DSFont = .body1Bold,
        hasBackButton: Bool = true,
        barHeight: CGFloat = UIDevice.isPhone ? 64 : 72,
        bgColor: [Color] = [Color(DSColor.primaryWhite)],
        @ViewBuilder leadingView: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailingView: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.titleTextStyle = TextStyler(
            font: titleFont.font,
            color: Color(DSColor.black)
        )
        self.hasBackButton = hasBackButton
        self.barHeight = barHeight
        self.bgColor = bgColor
        self.leadingView = leadingView
        self.trailingView = trailingView
    }

    // MARK: - View Body
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center, spacing: 4) {
                if hasBackButton {
                    Image("ic_chevron_left")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: isPhone ? 24 : 28, height: isPhone ? 24 : 28)
                        .foregroundStyle(Color(DSColor.primaryWhite))
                        .padding(8)
                        .contentShape(.rect)
                        .asButton {
                            dismiss()
                        }
                }
                leadingView()
                    .frameHorizontalExpand(alignment: .leading)
                trailingView()
                    .frameHorizontalExpand(alignment: .trailing)
            }
            .frameHorizontalExpand(alignment: .leading)

            Text(title)
                .modifier(titleTextStyle)
                .lineLimit(1)
                .frameHorizontalExpand(alignment: .center)
                .padding(.horizontal, isPhone ? 40 : 44)
        }
        .frame(height: barHeight, alignment: .center)
        .clipped()
        .padding(.horizontal, 16)
        .ignoresSafeArea(.keyboard, edges: .all)
        .background(LinearGradient(
            colors: bgColor,
            startPoint: .top,
            endPoint: .bottom
        ), ignoresSafeAreaEdges: .all)
    }
}


#Preview {
    VStack {
        CustomNavBarView(
            title: "Navigation Title",
            hasBackButton: false
        )
        .frame(height: 120, alignment: .center)
    }
}

