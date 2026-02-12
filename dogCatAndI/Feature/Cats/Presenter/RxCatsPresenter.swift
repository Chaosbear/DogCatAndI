//
//  RxCatsPresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 12/2/2569 BE.
//

import Foundation
import RxSwift
import RxCocoa
import OrderedCollections

class RxCatsViewState {
    let breeds = BehaviorRelay<OrderedDictionary<String, Cats.FetchBreeds.ViewModel.BreedItem>>(value: [:])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorState = BehaviorRelay<ErrorViewStateModel>(value: .noError)
    let expandedBreedId = BehaviorRelay<String?>(value: nil)
}

class RxCatsPresenter: CatsPresentationLogic {
    let viewState: RxCatsViewState

    init(viewState: RxCatsViewState) {
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

        if isReplace {
            viewState.breeds.accept(dict)
        } else {
            var current = viewState.breeds.value
            current.merge(dict, uniquingKeysWith: { _, new in new })
            viewState.breeds.accept(current)
        }
    }

    func presentLoading(_ isLoading: Bool) {
        viewState.isLoading.accept(isLoading)
    }

    func presentErrorState(_ state: ErrorViewStateModel) {
        viewState.errorState.accept(state)
    }
}
