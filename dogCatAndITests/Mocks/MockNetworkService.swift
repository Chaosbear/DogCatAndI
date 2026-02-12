import Foundation
import Alamofire
@testable import dogCatAndI

class MockNetworkService: NetworkServiceProtocol {
    var mockData: Any?
    var mockError: Error?
    var fetchCallCount = 0

    func request<T: Decodable>(
        method: HTTPMethod,
        url: URL,
        parameters: Parameters?,
        cachePolicy: URLRequest.CachePolicy
    ) async throws -> T {
        fetchCallCount += 1
        if let error = mockError {
            throw error
        }
        guard let data = mockData as? T else {
            throw NetworkError.serverError(0)
        }
        return data
    }

    func request<T: Decodable>(
        method: HTTPMethod,
        url: URL?,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: [String: String],
        cachePolicy: URLRequest.CachePolicy,
        timeout: Double
    ) async throws -> T {
        try await request(
            method: method,
            url: url!,
            parameters: parameters,
            cachePolicy: cachePolicy
        )
    }
}
