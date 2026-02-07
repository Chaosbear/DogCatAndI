//
//  MainTabView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import SwiftUI

// MARK: - Main Tab View

struct MainTabView: View {
    @StateObject private var container = AppContainer()
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            topBar

            Divider()

            // Tab Content
            TabView(selection: $selectedTab) {
                DogsView(store: container.dogsStore, interactor: container.dogsInteractor)
                    .tabItem {
                        Image("dog")
                        Text("Dogs")
                    }
                    .tag(0)

                CatsView(store: container.catsStore, interactor: container.catsInteractor)
                    .tabItem {
                        Image("cat")
                        Text("Cats")
                    }
                    .tag(1)

                MeView(store: container.meStore, interactor: container.meInteractor)
                    .tabItem {
                        Image("profile")
                        Text("Me")
                    }
                    .tag(2)
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Image("pet")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)

            Spacer()

            Text("Dog + Cat & I")
                .font(.system(size: 18, weight: .bold))

            Spacer()

            Button(action: {
                selectedTab = 2
            }) {
                Image("account")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}
