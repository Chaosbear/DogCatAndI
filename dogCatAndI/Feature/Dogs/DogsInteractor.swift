//
//  DogsInteractor.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Dogs Business Logic

protocol DogsBusinessLogic: AnyObject {
    func fetchDogs(request: Dogs.FetchDogs.Request)
}

// MARK: - Dogs Interactor

class DogsInteractor: DogsBusinessLogic {
    var presenter: DogsPresentationLogic
    var worker: DogsWorkerProtocol

    init(presenter: DogsPresentationLogic, worker: DogsWorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }

    func fetchDogs(request: Dogs.FetchDogs.Request) {
        switch request.loadType {
        case .concurrent:
            fetchDogsConcurrently()
        case .sequential:
            fetchDogsSequentially()
        }
    }

    // MARK: - Private

    private func fetchDogsConcurrently() {
        presenter.presentLoading(true)

        Task {
            var results: [(Int, DogAPIResponse?, Date)] = []

            await withTaskGroup(of: (Int, DogAPIResponse?, Date).self) { group in
                for i in 0..<3 {
                    group.addTask { [weak self] in
                        let timestamp = Date()
                        let response = try? await self?.worker.fetchRandomDogImage()
                        return (i, response, timestamp)
                    }
                }

                for await result in group {
                    results.append(result)
                }
            }

            results.sort { $0.0 < $1.0 }

            let dogImages = results.compactMap { index, response, timestamp -> Dogs.FetchDogs.Response.DogImage? in
                guard let response = response else { return nil }
                return Dogs.FetchDogs.Response.DogImage(
                    imageURL: response.message,
                    timestamp: timestamp,
                    index: index
                )
            }

            presenter.presentDogs(response: Dogs.FetchDogs.Response(dogImages: dogImages, error: nil))
            presenter.presentLoading(false)
        }
    }

    private func fetchDogsSequentially() {
        presenter.presentLoading(true)

        Task {
            let now = Date()
            let calendar = Calendar.current
            let second = calendar.component(.second, from: now)
            let lastDigit = second % 10
            let delayNanoseconds: UInt64 = lastDigit < 5 ? 2_000_000_000 : 3_000_000_000

            var dogImages: [Dogs.FetchDogs.Response.DogImage] = []

            for i in 0..<3 {
                if i > 0 {
                    try? await Task.sleep(nanoseconds: delayNanoseconds)
                }

                let timestamp = Date()
                if let response = try? await worker.fetchRandomDogImage() {
                    dogImages.append(Dogs.FetchDogs.Response.DogImage(
                        imageURL: response.message,
                        timestamp: timestamp,
                        index: i
                    ))
                }
            }

            presenter.presentDogs(response: Dogs.FetchDogs.Response(dogImages: dogImages, error: nil))
            presenter.presentLoading(false)
        }
    }
}
