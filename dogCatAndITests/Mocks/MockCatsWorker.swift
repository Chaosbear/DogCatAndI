import Foundation
@testable import dogCatAndI

class MockCatsWorker: CatsWorkerProtocol {
    var mockResponse: CatBreedsAPIResponse?
    var mockError: Error?
    var fetchCallCount = 0

    func fetchCatBreeds(page: Int) async throws -> CatBreedsAPIResponse {
        fetchCallCount += 1
        if let error = mockError {
            throw error
        }
        return mockResponse ?? CatBreedsAPIResponse(
            currentPage: 1,
            data: [
                CatBreed(breed: "Persian", country: "Iran", origin: "Natural", coat: "Long", pattern: "Solid"),
                CatBreed(breed: "Siamese", country: "Thailand", origin: "Natural", coat: "Short", pattern: "Colorpoint")
            ]
        )
    }
}
