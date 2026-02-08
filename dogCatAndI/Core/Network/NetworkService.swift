//
//  NetworkService.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation
import Alamofire
import netfox

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse(error: Error, data: Data)
    case serverError(Int)
    case internetConnectionError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse(let error, _):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .internetConnectionError:
            return "No Internet Connection"
        }
    }
}

// MARK: - Network Service Protocol

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        method: HTTPMethod,
        url: URL,
        parameters: Parameters?
    ) async throws -> T
    func request<T: Decodable>(
        method: HTTPMethod,
        url: URL?,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: [String: String],
        timeout: Double
    ) async throws -> T
}

// MARK: - Network Service

class NetworkService: NetworkServiceProtocol {
    // MARK: - Property
    static let shared = NetworkService()
    private let session: Session
    private let nwMonitorService: NWMonitorServiceProtocol

    // MARK: - Init
    init(
        session: Session = Session.default,
        nwMonitorService: NWMonitorServiceProtocol = NWMonitorService.shared
    ) {
        self.nwMonitorService = nwMonitorService
        #if DEBUG
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(NFXProtocol.self, at: 0)
        let nfxSession = Session(configuration: configuration)
        self.session = nfxSession
        #else
        if Config.enableNetFox {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses?.insert(NFXProtocol.self, at: 0)
            let nfxSession = Session(configuration: configuration)
            self.session = nfxSession
        } else {
            self.session = session
        }
        #endif
    }

    // MARK: - Request Config
    private func successStatusCodes() -> ClosedRange<Int> {
        return 200...299
    }

    // MARK: - Request
    func request<T: Decodable>(
        method: HTTPMethod,
        url: URL,
        parameters: Parameters?
    ) async throws -> T {
        try await request(
            method: method,
            url: url,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: [:],
            timeout: 60
        )
    }

    func request<T: Decodable>(
        method: HTTPMethod,
        url: URL?,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: [String: String],
        timeout: Double
    ) async throws -> T {
        guard let url else { throw NetworkError.invalidURL }

        let dataResponse = await session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: HTTPHeaders(headers)
        ) {
            $0.cachePolicy = .reloadIgnoringLocalCacheData
            $0.timeoutInterval = timeout
        }
        .validate(statusCode: successStatusCodes())
        .serializingDecodable(T.self).response

        switch dataResponse.result {
        case .success(let value):
            return value
        case .failure(let error):
            guard let errData = dataResponse.data else {
                throw nwMonitorService.isConnected
                ? NetworkError.serverError(dataResponse.response?.statusCode ?? 0)
                : NetworkError.internetConnectionError
            }
            throw NetworkError.invalidResponse(error: error, data: errData)
        }
    }
}

