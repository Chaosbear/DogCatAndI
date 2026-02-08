//
//  CatsInteractor.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Cats Business Logic
protocol CatsBusinessLogic: AnyObject {
    func fetchBreeds() async
    func refreshBreeds() async
}

class CatsInteractor: CatsBusinessLogic {
    // MARK: - Property
    private var isLoading = false
    private var pagination = PaginationModel()

    // MARK: - Dependency
    var presenter: CatsPresentationLogic
    var worker: CatsWorkerProtocol

    // MARK: - Init
    init(
        presenter: CatsPresentationLogic,
        worker: CatsWorkerProtocol
    ) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Action
    func fetchBreeds() async {
        guard !isLoading && pagination.hasNext else { return }
        isLoading = true
        presenter.presentLoading(true)

        do {
            let apiResponse = try await worker.fetchCatBreeds()

            pagination.loadedPage = apiResponse.currentPage ?? (pagination.loadedPage + 1)
            pagination.hasNext = apiResponse.nextPageURL != nil

            presenter.presentBreeds(
                response: Cats.FetchBreeds.Response(breeds: apiResponse.data),
                isReplace: pagination.loadedPage <= 1
            )

            presenter.presentErrorState(.noError)
        } catch {
            if let networkError = error as? NetworkError, case .internetConnectionError = networkError {
                presenter.presentErrorState(.noInternetError)
            } else {
                presenter.presentErrorState(.systemError)
            }
        }
        isLoading = false
        presenter.presentLoading(false)
    }

    func refreshBreeds() async {
        guard !isLoading else { return }
        pagination = .init()
        await fetchBreeds()
    }
}
