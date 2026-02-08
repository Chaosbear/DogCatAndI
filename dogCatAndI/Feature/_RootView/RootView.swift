//
//  RootView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import SwiftUI

struct RootView: View {
    // MARK: - Type
    enum MainTab: String, CaseIterable {
        case dogs = "Dogs"
        case cats = "cats"
        case me = "Me"

        var image: String {
            switch self {
            case .dogs: "ic_dog"
            case .cats: "ic_cat"
            case .me: "ic_profile"
            }
        }
    }

    // MARK: - Property
    @StateObject private var container = AppContainer()
    @State private var selectedTab: MainTab = .dogs

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 0) {
            navBar
            content
            tabBar
        }
    }

    // MARK: - View Component
    @ViewBuilder
    private var navBar: some View {
        CustomNavBarView(
            title: "Dog + Cat & I",
            titleFont: .h2,
            hasBackButton: false,
            barHeight: 64,
            leadingView: {
                Image("ic_dog_n_cat")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(Color(DSColor.secondaryBlue))
                    .frame(width: 56, height: 56)
            },
            trailingView: {
                Image("ic_account")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(Color(DSColor.black))
                    .frame(width: 56, height: 56)
            }
        )
    }

    @ViewBuilder
    private var tabBar: some View {
        let binding = Binding<CustomTabbarItem>(
            get: { .init(
                id: selectedTab.rawValue,
                title: selectedTab.rawValue,
                image: selectedTab.image
            )},
            set: {
                if let newTab = MainTab.init(rawValue: $0.id), newTab != selectedTab {
                    selectedTab = newTab
                }
            }
        )
        CustomTabbarView(
            selectedTab: binding,
            tabs: MainTab.allCases.map { tab in
                CustomTabbarItem(
                    id: tab.rawValue,
                    title: tab.rawValue,
                    image: tab.image
                )
            }
        )
    }

    @ViewBuilder
    private var content: some View {
        TabView(selection: $selectedTab) {
            DogsView(
                selectedTab: $selectedTab,
                viewState: container.dogsViewState,
                interactor: container.dogsInteractor
            )
            .tag(MainTab.dogs)
            CatsView(
                selectedTab: $selectedTab,
                viewState: container.catsViewState,
                interactor: container.catsInteractor
            )
            .tag(MainTab.cats)
            MeView(
                selectedTab: $selectedTab,
                viewState: container.meViewState,
                interactor: container.meInteractor
            )
            .tag(MainTab.me)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    RootView()
}
