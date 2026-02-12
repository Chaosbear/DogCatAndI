//
//  DogsView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import SwiftUI
import Combine

@MainActor
class DogsViewState: ObservableObject {
    @Published var dogs: [Dogs.FetchDogs.ViewModel.DogItem] = []
    @Published var isLoading = false
    @Published var errorState: ErrorViewStateModel = .noError
    var currentLoadType: Dogs.FetchDogs.Request.LoadType = .concurrent
}

struct DogsView: View {
    // MARK: - Property
    @Binding var selectedTab: RootView.MainTab

    // MARK: - Text Style
    private let titleTextStyle = TextStyler(
        font: DSFont.h1.font,
        color: Color(DSColor.black)
    )
    private let buttonTextStyle = TextStyler(
        font: DSFont.body3.font,
        color: Color(DSColor.primaryWhite)
    )

    // MARK: - Layout
    private let sidePadding: CGFloat = 16
    private var gridColumns = [GridItem(
        .adaptive(minimum: 120, maximum: 240),
        spacing: 16,
        alignment: .top
    )]

    // MARK: - Dependency
    @ObservedObject private var viewState: DogsViewState
    private let interactor: DogsBusinessLogic

    // MARK: - Init
    init(
        selectedTab: Binding<RootView.MainTab>,
        viewState: DogsViewState,
        interactor: DogsBusinessLogic
    ) {
        self._selectedTab = selectedTab
        self.viewState = viewState
        self.interactor = interactor
    }

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 0) {
            title
            ZStack {
                dogList
                if viewState.isLoading && viewState.errorState == .noError {
                    dogListSkelton
                }
                if viewState.errorState != .noError {
                    errorView
                }
            }
            .frameExpand()
            loadButtonStack
        }
        .background(Color(DSColor.primaryWhite))
        .onViewDidLoad {
            if viewState.dogs.isEmpty && selectedTab == .dogs {
                interactor.fetchDogs(loadType: viewState.currentLoadType)
            }
        }
        .onChange(of: selectedTab) { newTab in
            if newTab == .dogs && viewState.dogs.isEmpty {
                interactor.fetchDogs(loadType: viewState.currentLoadType)
            }
        }
    }

    // MARK: - View Component
    @ViewBuilder
    private var title: some View {
        Text("Dogs")
            .modifier(titleTextStyle)
            .frameHorizontalExpand(alignment: .leading)
            .padding(.top, 12)
            .padding(.bottom, 6)
            .padding(.horizontal, sidePadding)
    }

    @ViewBuilder
    private var dogList: some View {
        ScrollView {
            LazyVGrid(
                columns: gridColumns,
                alignment: .center,
                spacing: sidePadding
            ) {
                ForEach(viewState.dogs) { dog in
                    DogCardView(dog: dog)
                }
            }
            .padding([.horizontal, .bottom], sidePadding)
            .padding(.top, 6)
        }
    }

    @ViewBuilder
    private var dogListSkelton: some View {
        ScrollView {
            LazyVGrid(
                columns: gridColumns,
                alignment: .center,
                spacing: sidePadding
            ) {
                ForEach(1...3, id: \.self) { _ in
                    DogCardSkeletonView()
                }
            }
            .padding([.horizontal, .bottom], sidePadding)
            .padding(.top, 6)
        }
        .background(Color(DSColor.primaryWhite))
    }

    @ViewBuilder
    private var loadButtonStack: some View {
        HStack(spacing: 32) {
            Text("Concurrent\nReload")
                .modifier(buttonTextStyle)
                .padding(4)
                .frame(height: 40)
                .frame(maxWidth: 240)
                .background(Color(DSColor.primaryBlue))
                .cornerRadiusWithBorder(Color(DSColor.black), radius: 8, width: 1, corners: .allCorners)
                .asButton {
                    interactor.fetchDogs(loadType: .concurrent)
                }
                .frameHorizontalExpand(alignment: .center)
            Text("Sequential\nReload")
                .modifier(buttonTextStyle)
                .padding(4)
                .frame(height: 40)
                .frame(maxWidth: 240)
                .background(Color(DSColor.primaryBlue))
                .cornerRadiusWithBorder(Color(DSColor.black), radius: 8, width: 1, corners: .allCorners)
                .asButton {
                    interactor.fetchDogs(loadType: .sequential)
                }
                .frameHorizontalExpand(alignment: .center)
        }
        .multilineTextAlignment(.center)
        .lineSpacing(2)
        .padding(.horizontal, 32)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var errorView: some View {
        ErrorView(state: viewState.errorState) {
            interactor.fetchDogs(loadType: viewState.currentLoadType)
        }
        .disabled(viewState.isLoading)
        .expandInScrollView()
        .background(Color(DSColor.primaryWhite))
    }
}

#if DEBUG
private final class PreviewDogsInteractor: DogsBusinessLogic {
    func fetchDogs(loadType: Dogs.FetchDogs.Request.LoadType) {}
}

#Preview {
    let viewState = DogsViewState()
    viewState.errorState = .noInternetError
    viewState.dogs = [
        Dogs.FetchDogs.ViewModel.DogItem(id: 0, imageURL: URL(string: "https://images.dog.ceo/breeds/labrador/n02099712_001.jpg"), label: "Dog #1 - Labrador (12:00:00)"),
        Dogs.FetchDogs.ViewModel.DogItem(id: 1, imageURL: URL(string: "https://images.dog.ceo/breeds/poodle-standard/n02113799_001.jpg"), label: "Dog #2 - Poodle (12:00:01)"),
        Dogs.FetchDogs.ViewModel.DogItem(id: 2, imageURL: nil, label: "Dog #3 - Unknown (12:00:02)")
    ]
    return DogsView(
        selectedTab: .constant(.dogs),
        viewState: viewState,
        interactor: PreviewDogsInteractor()
    )
}
#endif
