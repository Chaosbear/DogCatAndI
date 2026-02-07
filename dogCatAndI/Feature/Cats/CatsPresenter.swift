//
//  CatsPresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Cats Presentation Logic

protocol CatsPresentationLogic: AnyObject {
    func presentBreeds(response: Cats.FetchBreeds.Response)
    func presentLoading(_ isLoading: Bool)
}

// MARK: - Cats Presenter

class CatsPresenter: CatsPresentationLogic {
    weak var store: CatsStore?

    init(store: CatsStore) {
        self.store = store
    }

    func presentBreeds(response: Cats.FetchBreeds.Response) {
        let items = response.breeds.map { breed in
            Cats.FetchBreeds.ViewModel.BreedItem(
                id: breed.breed,
                breed: breed.breed,
                country: breed.country,
                origin: breed.origin,
                coat: breed.coat,
                pattern: breed.pattern
            )
        }

        let viewModel = Cats.FetchBreeds.ViewModel(breeds: items)

        DispatchQueue.main.async { [weak self] in
            self?.store?.breeds = viewModel.breeds
            if let error = response.error {
                self?.store?.errorMessage = error
            }
        }
    }

    func presentLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.store?.isLoading = isLoading
        }
    }
}
