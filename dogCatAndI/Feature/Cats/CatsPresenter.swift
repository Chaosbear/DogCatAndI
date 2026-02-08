//
//  CatsPresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Cats Presentation Logic

protocol CatsPresentationLogic: AnyObject {
    func presentBreeds(response: Cats.FetchBreeds.Response, isReplace: Bool)
    func presentLoading(_ isLoading: Bool)
    func presentErrorState(_ state: ErrorViewStateModel)
}

// MARK: - Cats Presenter

class CatsPresenter: CatsPresentationLogic {
    weak var viewState: CatsViewState?

    init(viewState: CatsViewState) {
        self.viewState = viewState
    }

    func presentBreeds(response: Cats.FetchBreeds.Response, isReplace: Bool) {
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
        if isReplace {
            viewState?.breeds = viewModel.breeds
        } else {
            viewState?.breeds.append(contentsOf: viewModel.breeds)
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
