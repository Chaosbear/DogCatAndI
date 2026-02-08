//
//  MeInteractor.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Me Business Logic

protocol MeBusinessLogic: AnyObject {
    func fetchProfile(request: Me.FetchProfile.Request)
}

// MARK: - Me Interactor
class MeInteractor: MeBusinessLogic {
    // MARK: - Property
    private var isLoading = false

    // MARK: - Dependency
    var presenter: MePresentationLogic
    var worker: MeWorkerProtocol

    // MARK: - Init
    init(
        presenter: MePresentationLogic,
        worker: MeWorkerProtocol
    ) {
        self.presenter = presenter
        self.worker = worker
    }

    func fetchProfile(request: Me.FetchProfile.Request) {
        Task {
            guard !isLoading else { return }
            isLoading = true
            presenter.presentLoading(true)

            do {
                let apiResponse = try await worker.fetchRandomUser()
                let user = apiResponse.results.first
                presenter.presentProfile(response: Me.FetchProfile.Response(user: user))
                presenter.presentErrorState(.noError)
            } catch {
                presenter.presentProfile(response: Me.FetchProfile.Response(user: nil))
                if let networkError = error as? NetworkError, case .internetConnectionError = networkError {
                    presenter.presentErrorState(.noInternetError)
                } else {
                    presenter.presentErrorState(.systemError)
                }
            }
            isLoading = false
            presenter.presentLoading(false)
        }
    }
}
