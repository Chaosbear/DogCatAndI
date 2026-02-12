//
//  CatsView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import SwiftUI
import Combine
import OrderedCollections

@MainActor
class CatsViewState: ObservableObject {
    @Published var breeds: OrderedDictionary<String, Cats.FetchBreeds.ViewModel.BreedItem> = [:]
    @Published var isLoading = false
    @Published var errorState: ErrorViewStateModel = .noError
    @Published var expandedBreedId: String?
}

struct CatsView: View {
    // MARK: - Property
    @Binding var selectedTab: RootView.MainTab

    // MARK: - Text Style
    private let titleTextStyle = TextStyler(
        font: DSFont.h1.font,
        color: Color(DSColor.black)
    )
    private let subtitleTextStyle = TextStyler(
        font: DSFont.h3.font,
        color: Color(DSColor.black)
    )

    // MARK: - Layout
    private let sidePadding: CGFloat = 16

    // MARK: - Dependency
    @ObservedObject var viewState: CatsViewState
    private let interactor: CatsBusinessLogic

    // MARK: - Init
    init(
        selectedTab: Binding<RootView.MainTab>,
        viewState: CatsViewState,
        interactor: CatsBusinessLogic
    ) {
        self._selectedTab = selectedTab
        self.viewState = viewState
        self.interactor = interactor
    }

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 0) {
            title
            catContent
        }
        .background(Color(DSColor.primaryWhite))
        .taskOnViewDidLoad {
            if await viewState.breeds.isEmpty && selectedTab == .cats {
                await interactor.fetchBreeds()
            }
        }
        .onChange(of: selectedTab) { newTab in
            Task {
                if newTab == .cats && viewState.breeds.isEmpty {
                    await interactor.fetchBreeds()
                }
            }
        }
    }

    // MARK: - View Component
    @ViewBuilder
    private var title: some View {
        Text("Cats")
            .modifier(titleTextStyle)
            .frameHorizontalExpand(alignment: .leading)
            .padding(.top, 12)
            .padding([.horizontal, .bottom], sidePadding)
    }

    @ViewBuilder
    private var catContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Cat Breeds")
                .modifier(subtitleTextStyle)
                .frameHorizontalExpand(alignment: .leading)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            HDividerView()

            if !viewState.breeds.isEmpty {
                catList
            } else {
                if viewState.errorState != .noError {
                    errorView
                } else {
                    if viewState.isLoading {
                        catListSkelton
                    } else {
                        catList
                    }
                }
            }
        }
        .border(Color(DSColor.black))
        .padding(.horizontal, sidePadding)
    }

    @ViewBuilder
    private var catList: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(viewState.breeds.values) { breed in
                        CatCardView(
                            expandBreedId: $viewState.expandedBreedId,
                            breed: breed
                        )
                        .onAppear {
                            if breed.id == viewState.breeds.keys.last {
                                Task {
                                    await interactor.fetchBreeds()
                                }
                            }
                        }
                    }
                }
                if !viewState.breeds.isEmpty {
                    if viewState.errorState != .noError {
                        fetchMoreErrorView
                    } else if viewState.isLoading {
                        ProgressView()
                            .padding(.vertical, 12)
                            .frameHorizontalExpand(alignment: .center)
                    }
                }
            }
            .padding(.bottom, sidePadding)
        }
        .refreshableWithDelay {
            await interactor.refreshBreeds()
        }
    }

    @ViewBuilder
    private var catListSkelton: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                ForEach(1...3, id: \.self) { _ in
                    CatCardSkeletonView()
                }
            }
            .padding(.bottom, sidePadding)
        }
    }

    @ViewBuilder
    private var errorView: some View {
        ErrorView(state: viewState.errorState) {
            Task {
                await interactor.fetchBreeds()
            }
        }
        .disabled(viewState.isLoading)
        .expandInScrollView()
        .background(Color(DSColor.primaryWhite))
    }

    @ViewBuilder
    private var fetchMoreErrorView: some View {
        ErrorView(
            imageName: nil,
            title: viewState.errorState.title,
            message: viewState.errorState.message
        ) {
            Task {
                await interactor.fetchBreeds()
            }
        }
        .disabled(viewState.isLoading)
        .frameHorizontalExpand(alignment: .center)
    }
}

// MARK: - Preview

#if DEBUG
private class PreviewCatsInteractor: CatsBusinessLogic {
    func fetchBreeds() async {}
    func refreshBreeds() async {}
}

#Preview {
    let viewState = CatsViewState()
    viewState.breeds = [
        "Persian": Cats.FetchBreeds.ViewModel.BreedItem(
            id: "Persian",
            breed: "Persian",
            country: "Iran",
            origin: "Natural",
            coat: "Long",
            pattern: "Solid"
        ),
        "Siamese" : Cats.FetchBreeds.ViewModel.BreedItem(
            id: "Siamese",
            breed: "Siamese",
            country: "Thailand",
            origin: "Natural",
            coat: "Short",
            pattern: "Colorpoint"
        ),
        "Maine Coon" : Cats.FetchBreeds.ViewModel.BreedItem(
            id: "Maine Coon",
            breed: "Maine Coon",
            country: "United States",
            origin: "Natural",
            coat: "Long",
            pattern: "Tabby"
        )
    ]
    return CatsView(
        selectedTab: .constant(.cats),
        viewState: viewState,
        interactor: PreviewCatsInteractor()
    )
}
#endif
