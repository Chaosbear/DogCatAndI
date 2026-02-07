//
//  DogsPresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Dogs Presentation Logic

protocol DogsPresentationLogic: AnyObject {
    func presentDogs(response: Dogs.FetchDogs.Response)
    func presentLoading(_ isLoading: Bool)
}

// MARK: - Dogs Presenter

class DogsPresenter: DogsPresentationLogic {
    weak var store: DogsStore?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter
    }()

    init(store: DogsStore) {
        self.store = store
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

        DispatchQueue.main.async { [weak self] in
            self?.store?.dogs = viewModel.dogs
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
