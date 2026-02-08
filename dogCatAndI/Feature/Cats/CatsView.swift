//
//  CatsView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import SwiftUI
import Combine

// MARK: - Cats Store
@MainActor
class CatsViewState: ObservableObject {
    @Published var breeds: [Cats.FetchBreeds.ViewModel.BreedItem] = []
    @Published var isLoading = false
    @Published var errorState: ErrorViewStateModel = .noError
    @Published var expandedBreedId: String?
}

// MARK: - Cats View

struct CatsView: View {
    @ObservedObject var store: CatsViewState
    let interactor: CatsBusinessLogic

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Cat Breeds")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            // Breeds list
            List {
                ForEach(store.breeds) { breed in
                    breedRow(breed)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .loadingOverlay(isLoading: store.isLoading)
        .onAppear {
            if store.breeds.isEmpty {
                interactor.fetchBreeds(request: Cats.FetchBreeds.Request())
            }
        }
    }

    // MARK: - Breed Row

    @ViewBuilder
    private func breedRow(_ breed: Cats.FetchBreeds.ViewModel.BreedItem) -> some View {
        let isExpanded = store.expandedBreedId == breed.id

        VStack(alignment: .leading, spacing: 0) {
            // Header row - always visible
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if store.expandedBreedId == breed.id {
                        store.expandedBreedId = nil
                    } else {
                        store.expandedBreedId = breed.id
                    }
                }
            }) {
                HStack {
                    Text(breed.breed)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }

            // Expanded details
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    detailRow(label: "Country", value: breed.country)
                    detailRow(label: "Origin", value: breed.origin)
                    detailRow(label: "Coat", value: breed.coat)
                    detailRow(label: "Pattern", value: breed.pattern)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    @ViewBuilder
    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .frame(width: 70, alignment: .leading)

            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Preview

#if DEBUG
private class PreviewCatsInteractor: CatsBusinessLogic {
    func fetchBreeds(request: Cats.FetchBreeds.Request) {}
}

#Preview {
    let store = CatsStore()
    store.breeds = [
        Cats.FetchBreeds.ViewModel.BreedItem(id: "Persian", breed: "Persian", country: "Iran", origin: "Natural", coat: "Long", pattern: "Solid"),
        Cats.FetchBreeds.ViewModel.BreedItem(id: "Siamese", breed: "Siamese", country: "Thailand", origin: "Natural", coat: "Short", pattern: "Colorpoint"),
        Cats.FetchBreeds.ViewModel.BreedItem(id: "Maine Coon", breed: "Maine Coon", country: "United States", origin: "Natural", coat: "Long", pattern: "Tabby")
    ]
    return CatsView(store: store, interactor: PreviewCatsInteractor())
}
#endif
