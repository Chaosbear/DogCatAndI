//
//  CatsInteractor.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

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
            let apiResponse = try await worker.fetchCatBreeds(page: pagination.loadedPage + 1)

            pagination.loadedPage = apiResponse.currentPage ?? (pagination.loadedPage + 1)
            pagination.hasNext = apiResponse.nextPageURL != nil

            isLoading = false
            presenter.presentLoading(false)
            presenter.presentBreeds(
                response: Cats.FetchBreeds.Response(breeds: apiResponse.data),
                isReplace: pagination.loadedPage <= 1
            )

            presenter.presentErrorState(.noError)
        } catch {
            isLoading = false
            presenter.presentLoading(false)
            if let networkError = error as? NetworkError, case .internetConnectionError = networkError {
                presenter.presentErrorState(.noInternetError)
            } else {
                presenter.presentErrorState(.systemError)
            }
        }
    }

    func refreshBreeds() async {
        guard !isLoading else { return }
        pagination = .init()
        await fetchBreeds()
    }
}
