import Foundation
@testable import dogCatAndI

class MockDogsWorker: DogsWorkerProtocol {
    var mockResponse: DogAPIResponseModel?
    var mockError: Error?
    var fetchCallCount = 0

    func fetchRandomDogImage() async throws -> DogAPIResponseModel {
        fetchCallCount += 1
        if let error = mockError {
            throw error
        }
        return mockResponse ?? DogAPIResponseModel(message: "https://images.dog.ceo/breeds/test/test.jpg")
    }
}
