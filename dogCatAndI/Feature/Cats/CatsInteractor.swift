//
//  CatsInteractor.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Cats Business Logic

protocol CatsBusinessLogic: AnyObject {
    func fetchBreeds(request: Cats.FetchBreeds.Request)
}

// MARK: - Cats Interactor

class CatsInteractor: CatsBusinessLogic {
    var presenter: CatsPresentationLogic
    var worker: CatsWorkerProtocol

    init(presenter: CatsPresentationLogic, worker: CatsWorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }

    func fetchBreeds(request: Cats.FetchBreeds.Request) {
        presenter.presentLoading(true)

        Task {
            do {
                let apiResponse = try await worker.fetchCatBreeds()
                presenter.presentBreeds(response: Cats.FetchBreeds.Response(
                    breeds: apiResponse.data,
                    error: nil
                ))
            } catch {
                presenter.presentBreeds(response: Cats.FetchBreeds.Response(
                    breeds: [],
                    error: error.localizedDescription
                ))
            }

            presenter.presentLoading(false)
        }
    }
}
