//
//  DogsWorker.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation
import Alamofire

// MARK: - Dogs Worker Protocol

protocol DogsWorkerProtocol {
    func fetchRandomDogImage() async throws -> DogAPIResponse
}

// MARK: - Dogs Worker

class DogsWorker: DogsWorkerProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchRandomDogImage() async throws -> DogAPIResponse {
        return try await networkService.request(
            method: .get,
            url: Config.dogURL.appending(path: "api/breeds/image/random"),
            parameters: nil
        )
    }
}
