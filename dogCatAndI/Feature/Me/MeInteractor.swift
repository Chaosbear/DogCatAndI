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
    var presenter: MePresentationLogic
    var worker: MeWorkerProtocol

    init(presenter: MePresentationLogic, worker: MeWorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }

    func fetchProfile(request: Me.FetchProfile.Request) {
        presenter.presentLoading(true)

        Task {
            do {
                let apiResponse = try await worker.fetchRandomUser()
                let user = apiResponse.results.first
                presenter.presentProfile(response: Me.FetchProfile.Response(
                    user: user,
                    error: nil
                ))
            } catch {
                presenter.presentProfile(response: Me.FetchProfile.Response(
                    user: nil,
                    error: error.localizedDescription
                ))
            }

            presenter.presentLoading(false)
        }
    }
}
