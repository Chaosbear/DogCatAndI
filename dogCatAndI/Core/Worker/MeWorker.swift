//
//  MeWorker.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation
import Alamofire

// MARK: - Me Worker Protocol
protocol MeWorkerProtocol {
    func fetchRandomUser() async throws -> RandomUserAPIResponse
}

// MARK: - Me Worker
class MeWorker: MeWorkerProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchRandomUser() async throws -> RandomUserAPIResponse {
        return try await networkService.request(
            method: .get,
            url: Config.meURL.appending(path: "api"),
            parameters: nil
        )
    }
}
