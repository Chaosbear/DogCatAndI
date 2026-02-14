//
//  MeWorker.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation
import Alamofire

// MARK: - Me Worker Protocol
protocol MeWorkerProtocol: Sendable {
    func fetchRandomUser() async throws -> RandomUserAPIResponse
}

// MARK: - Me Worker
final class MeWorker: MeWorkerProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchRandomUser() async throws -> RandomUserAPIResponse {
        let response: RandomUserAPIResponse = try await networkService.request(
            method: .get,
            url: Config.meURL.appending(path: "api"),
            parameters: nil,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        if response.results.isEmpty {
            throw NetworkError.invalidResponse(error: nil, data: nil)
        }
        return response
    }
}
