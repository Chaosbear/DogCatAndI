//
//  DogsView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import SwiftUI
import Combine

// MARK: - Dogs Store
@MainActor
class DogsViewState: ObservableObject {
    @Published var dogs: [Dogs.FetchDogs.ViewModel.DogItem] = []
    @Published var isLoading = false
    @Published var errorState: ErrorViewStateModel = .noError
}

// MARK: - Dogs View

struct DogsView: View {
    // MARK: - Property
    @Binding var selectedTab: RootView.MainTab

    // MARK: - Dependency
    @ObservedObject private var viewState: DogsViewState
    private let interactor: DogsBusinessLogic

    // MARK: - Layout
    private var gridColumns: [GridItem] {
        return [GridItem(
            .adaptive(minimum: 120, maximum: 240),
            spacing: 12,
            alignment: .top
        )]
    }

    // MARK: - Init
    init(
        selectedTab: RootView.MainTab,
        viewState: DogsViewState,
        interactor: DogsBusinessLogic
    ) {
        self.viewState = viewState
        self.selectedTab = selectedTab
        self.interactor = interactor
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(store.dogs) { dog in
                        dogCard(dog)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }

            Spacer(minLength: 0)

            // Bottom buttons
            HStack(spacing: 16) {
                Button(action: {
                    interactor.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .concurrent))
                }) {
                    Text("Concurrent Reload")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }

                Button(action: {
                    interactor.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .sequential))
                }) {
                    Text("Sequential Reload")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
        .loadingOverlay(isLoading: store.isLoading)
        .onAppear {
            if store.dogs.isEmpty {
                interactor.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .concurrent))
            }
        }
    }

    // MARK: - Dog Card

    @ViewBuilder
    private func dogCard(_ dog: Dogs.FetchDogs.ViewModel.DogItem) -> some View {
        VStack(spacing: 8) {
            AsyncImage(url: dog.imageURL) { phase in
                switch phase {
                case .empty:
                    Image("image_placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(8)
                case .failure:
                    Image("image_placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }

            Text(dog.label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview
#if DEBUG
private final class PreviewDogsInteractor: DogsBusinessLogic {
    func fetchDogs(loadType: Dogs.FetchDogs.Request.LoadType) {}
    func retryFetch() {}
}

#Preview {
    let store = DogsViewState()
    store.dogs = [
        Dogs.FetchDogs.ViewModel.DogItem(id: 0, imageURL: URL(string: "https://images.dog.ceo/breeds/labrador/n02099712_001.jpg"), label: "Dog #1 - Labrador (12:00:00)"),
        Dogs.FetchDogs.ViewModel.DogItem(id: 1, imageURL: URL(string: "https://images.dog.ceo/breeds/poodle-standard/n02113799_001.jpg"), label: "Dog #2 - Poodle (12:00:01)"),
        Dogs.FetchDogs.ViewModel.DogItem(id: 2, imageURL: nil, label: "Dog #3 - Unknown (12:00:02)")
    ]
    return DogsView(store: store, interactor: PreviewDogsInteractor())
}
#endif
