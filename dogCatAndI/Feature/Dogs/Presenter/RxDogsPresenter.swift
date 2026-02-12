//
//  RxDogsPresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 10/2/2569 BE.
//

import Foundation
import RxSwift
import RxCocoa

class RxDogsViewState {
    let dogs = BehaviorRelay<[Dogs.FetchDogs.ViewModel.DogItem]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorState = BehaviorRelay<ErrorViewStateModel>(value: .noError)
    var currentLoadType: Dogs.FetchDogs.Request.LoadType = .concurrent
}

class RxDogsPresenter: DogsPresentationLogic {
    private weak var viewState: RxDogsViewState?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter
    }()

    init(viewState: RxDogsViewState) {
        self.viewState = viewState
    }

    func presentDogs(response: Dogs.FetchDogs.Response) {
        let items = response.dogImages.map { dog in
            let timestamp = dateFormatter.string(from: dog.timestamp)
            return Dogs.FetchDogs.ViewModel.DogItem(
                id: dog.index,
                imageURL: URL(string: dog.imageURL),
                label: "Dog#\(dog.index + 1) @ \(timestamp)"
            )
        }
        viewState?.dogs.accept(items)
    }

    func presentLoading(_ isLoading: Bool) {
        if viewState?.isLoading.value != isLoading {
            viewState?.isLoading.accept(isLoading)
        }
    }

    func presentErrorState(_ state: ErrorViewStateModel) {
        if viewState?.errorState.value != state {
            viewState?.errorState.accept(state)
        }
    }

    func setCurrentLoadType(loadType: Dogs.FetchDogs.Request.LoadType) {
        viewState?.currentLoadType = loadType
    }
}
