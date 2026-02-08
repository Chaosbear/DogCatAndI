//
//  CustomTabBarView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import SwiftUI
import UIKit

struct CustomTabbarItem: Hashable, Equatable {
    var id: String
    var title: String
    var image: String

    init(
        id: String,
        title: String,
        image: String
    ) {
        self.id = id
        self.title = title
        self.image = image
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

struct CustomTabbarView: View {
    // MARK: - Property
    @Binding var selectedTab: CustomTabbarItem
    private let tabs: [CustomTabbarItem]

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    private let isPhone = UIDevice.isPhone

    // MARK: - Init
    init(
        selectedTab: Binding<CustomTabbarItem>,
        tabs: [CustomTabbarItem]
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
    }

    // MARK: - View Body
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                CustomTabbarItemView(
                    tab: tab, selectedTab: $selectedTab,
                    isVertical: horizontalSizeClass == .compact
                )
            }
        }
        .padding(.horizontal, 24)
        .ignoresSafeArea(.all, edges: .horizontal)
        .ignoresSafeArea(.keyboard, edges: .all)
        .background(Color(DSColor.primaryWhite), ignoresSafeAreaEdges: .all)
    }
}

struct CustomTabbarItemView: View, Equatable {
    // MARK: - Property
    private let tab: CustomTabbarItem
    @Binding var selectedTab: CustomTabbarItem
    private let isVertical: Bool

    private let isPhone = UIDevice.isPhone

    // MARK: - Text Style
    private let titleTextStyle = TextStyler(
        font: DSFont.body2.font,
        color: Color(DSColor.black)
    )
    private let selectedTitleTextStyle = TextStyler(
        font: DSFont.body2Bold.font,
        color: Color(DSColor.primaryBlue)
    )

    static func == (lhs: CustomTabbarItemView, rhs: CustomTabbarItemView) -> Bool {
        lhs.tab == rhs.tab
        && lhs.selectedTab == rhs.selectedTab
        && lhs.isVertical == rhs.isVertical
    }

    // MARK: - Init
    init(
        tab: CustomTabbarItem,
        selectedTab: Binding<CustomTabbarItem>,
        isVertical: Bool
    ) {
        self.tab = tab
        self._selectedTab = selectedTab
        self.isVertical = isVertical
    }

    // MARK: - View Body
    var body: some View {
        if isVertical {
            VStack(alignment: .center, spacing: 4) {
                icon(tab)
                title(tab)
            }
            .padding(.top, isPhone ? 10 : 12)
            .padding(.bottom, isPhone ? 4 : 12)
            .frameHorizontalExpand(alignment: .center)
            .contentShape(.rect)
            .asButton {
                selectedTab = tab
            }
        } else {
            HStack(alignment: .center, spacing: isPhone ? 4 : 6) {
                icon(tab)
                title(tab)
            }
            .padding(.top, isPhone ? 10 : 12)
            .padding(.bottom, isPhone ? 4 : 12)
            .frameHorizontalExpand(alignment: .center)
            .contentShape(.rect)
            .asButton {
                selectedTab = tab
            }
        }
    }

    // MARK: - View Component
    @ViewBuilder
    private func icon(_ tab: CustomTabbarItem) -> some View {
        Image(tab.image)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: isPhone ? 28 : 32, height: isPhone ? 28 : 32)
            .foregroundColor(Color(DSColor.black))
    }

    @ViewBuilder
    private func title(_ tab: CustomTabbarItem) -> some View {
        Text(tab.title)
            .modifier(tab == selectedTab ? selectedTitleTextStyle : titleTextStyle)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
}
