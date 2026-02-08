//
//  CatsWorker.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation
import Alamofire

// MARK: - Cats Worker Protocol
protocol CatsWorkerProtocol {
    func fetchCatBreeds(page: Int) async throws -> CatBreedsAPIResponse
}

// MARK: - Cats Worker
final class CatsWorker: CatsWorkerProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchCatBreeds(page: Int) async throws -> CatBreedsAPIResponse {
        return try await networkService.request(
            method: .get,
            url: Config.catURL.appending(path: "breeds"),
            parameters: [
                "limit": 10,
                "page": page
            ]
        )
    }
}
