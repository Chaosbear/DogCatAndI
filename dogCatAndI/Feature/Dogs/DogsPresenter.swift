//
//  DogsPresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

protocol DogsPresentationLogic: AnyObject {
    func presentDogs(response: Dogs.FetchDogs.Response)
    func presentLoading(_ isLoading: Bool)
    func presentErrorState(_ state: ErrorViewStateModel)
    func setCurrentLoadType(loadType: Dogs.FetchDogs.Request.LoadType)
}

class DogsPresenter: DogsPresentationLogic {
    private var viewState: DogsViewState?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter
    }()

    init(viewState: DogsViewState) {
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

        let viewModel = Dogs.FetchDogs.ViewModel(dogs: items)
        viewState?.dogs = viewModel.dogs
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

    func setCurrentLoadType(loadType: Dogs.FetchDogs.Request.LoadType) {
        viewState?.currentLoadType = loadType
    }
}
