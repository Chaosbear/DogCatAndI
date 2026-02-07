import Foundation
@testable import dogCatAndI

class MockNetworkService: NetworkServiceProtocol {
    var mockData: Any?
    var mockError: Error?
    var fetchCallCount = 0

    func fetch<T: Decodable>(from url: URL) async throws -> T {
        fetchCallCount += 1
        if let error = mockError {
            throw error
        }
        guard let data = mockData as? T else {
            throw NetworkError.decodingError(NSError(domain: "Mock", code: 0))
        }
        return data
    }

    func fetchData(from url: URL) async throws -> Data {
        fetchCallCount += 1
        if let error = mockError {
            throw error
        }
        return Data()
    }
}
