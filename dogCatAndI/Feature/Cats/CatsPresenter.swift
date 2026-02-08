//
//  CatsPresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation
import OrderedCollections

protocol CatsPresentationLogic: AnyObject {
    func presentBreeds(response: Cats.FetchBreeds.Response, isReplace: Bool)
    func presentLoading(_ isLoading: Bool)
    func presentErrorState(_ state: ErrorViewStateModel)
}

class CatsPresenter: CatsPresentationLogic {
    weak var viewState: CatsViewState?

    init(viewState: CatsViewState) {
        self.viewState = viewState
    }

    func presentBreeds(response: Cats.FetchBreeds.Response, isReplace: Bool) {
        var dict: OrderedDictionary<String, Cats.FetchBreeds.ViewModel.BreedItem> = [:]
        response.breeds.forEach { breed in
            let item = Cats.FetchBreeds.ViewModel.BreedItem(
                id: breed.breed,
                breed: breed.breed,
                country: breed.country.withPlaceholder(),
                origin: breed.origin.withPlaceholder(),
                coat: breed.coat.withPlaceholder(),
                pattern: breed.pattern.withPlaceholder()
            )
            dict[breed.id] = item
        }

        let viewModel = Cats.FetchBreeds.ViewModel(breeds: dict)
        if isReplace {
            viewState?.breeds = viewModel.breeds
        } else {
            viewState?.breeds.merge(dict, uniquingKeysWith: { _, new in return new})
        }
    }

    func presentLoading(_ isLoading: Bool) {
        if viewState?.isLoading != isLoading {
            viewState?.isLoading = isLoading
        }
    }

    func presentErrorState(_ state: ErrorViewStateModel) {
        if viewState?.errorState != state {
            viewState?.errorState = state
        }
    }
}
