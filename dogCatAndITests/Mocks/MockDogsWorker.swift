import Foundation
@testable import dogCatAndI

class MockDogsWorker: DogsWorkerProtocol {
    var mockResponse: DogAPIResponse?
    var mockError: Error?
    var fetchCallCount = 0

    func fetchRandomDogImage() async throws -> DogAPIResponse {
        fetchCallCount += 1
        if let error = mockError {
            throw error
        }
        return mockResponse ?? DogAPIResponse(message: "https://images.dog.ceo/breeds/test/test.jpg", status: "success")
    }
}
