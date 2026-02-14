//
//  DogsInteractor.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

protocol DogsBusinessLogic: AnyObject, Sendable {
    func fetchDogs(loadType: Dogs.FetchDogs.Request.LoadType)
}

final class DogsInteractor: DogsBusinessLogic {
    // MARK: - Property
    private var isLoading = false

    // MARK: - Dependency
    var presenter: DogsPresentationLogic
    var worker: DogsWorkerProtocol

    // MARK: - Init
    init(
        presenter: DogsPresentationLogic,
        worker: DogsWorkerProtocol
    ) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Action
    func fetchDogs(loadType: Dogs.FetchDogs.Request.LoadType) {
        Task {
            guard !isLoading else { return }
            presenter.setCurrentLoadType(loadType: loadType)
            switch loadType {
            case .concurrent:
                await fetchDogsConcurrently()
            case .sequential:
                await fetchDogsSequentially()
            }
        }
    }

    private func fetchDogsConcurrently() async {
        isLoading = true
        presenter.presentLoading(true)

        var results: [(Int, DogAPIResponseModel?, Date, NetworkError?)] = []

        await withTaskGroup(of: (Int, DogAPIResponseModel?, Date, NetworkError?).self) { group in
            for i in 0..<3 {
                group.addTask { [weak self] in
                    let timestamp = Date()
                    do {
                        let response = try await self?.worker.fetchRandomDogImage()
                        return (i, response, timestamp, nil)
                    } catch {
                        return (i, nil, timestamp, error as? NetworkError)
                    }
                }
            }

            for await result in group {
                results.append(result)
            }
        }

        handleFetchResult(results: results)
    }

    private func fetchDogsSequentially() async {
        isLoading = true
        presenter.presentLoading(true)

        let now = Date()
        let calendar = Calendar.current
        let second = calendar.component(.second, from: now)
        let lastDigit = second % 10
        let delayNanoseconds: UInt64 = lastDigit < 5 ? 2_000_000_000 : 3_000_000_000

        var results: [(Int, DogAPIResponseModel?, Date, NetworkError?)] = []

        for i in 0..<3 {
            if i > 0 {
                try? await Task.sleep(nanoseconds: delayNanoseconds)
            }

            let timestamp = Date()
            do {
                let response = try await worker.fetchRandomDogImage()
                results.append((i, response, timestamp, nil))
            } catch {
                results.append((i, nil, timestamp, error as? NetworkError))
            }
        }

        handleFetchResult(results: results)
    }

    private func handleFetchResult(results: [(Int, DogAPIResponseModel?, Date, NetworkError?)]) {
        guard !results.contains(where: {
            if case .internetConnectionError = $0.3 {
                return true
            } else {
                return false
            }
        }) else {
            isLoading = false
            presenter.presentErrorState(.noInternetError)
            presenter.presentLoading(false)
            return
        }

        guard !results.isEmpty else {
            isLoading = false
            presenter.presentErrorState(.systemError)
            presenter.presentLoading(false)
            return
        }

        let dogImages = results
            .sorted(by: {$0.0 < $1.0})
            .compactMap { index, response, timestamp, error -> Dogs.FetchDogs.Response.DogImage? in
                guard let response = response else { return nil }
                return Dogs.FetchDogs.Response.DogImage(
                    imageURL: response.message,
                    timestamp: timestamp,
                    index: index
                )
            }

        isLoading = false
        presenter.presentErrorState(.noError)
        presenter.presentDogs(response: Dogs.FetchDogs.Response(dogImages: dogImages))
        presenter.presentLoading(false)
    }
}
