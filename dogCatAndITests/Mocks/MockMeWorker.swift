import Foundation
@testable import dogCatAndI

class MockMeWorker: MeWorkerProtocol {
    var mockResponse: RandomUserAPIResponse?
    var mockError: Error?
    var fetchCallCount = 0

    func fetchRandomUser() async throws -> RandomUserAPIResponse {
        fetchCallCount += 1
        if let error = mockError {
            throw error
        }
        return mockResponse ?? RandomUserAPIResponse(
            results: [
                RandomUserResult(
                    gender: "male",
                    name: RandomUserName(title: "Mr", first: "John", last: "Doe"),
                    location: RandomUserLocation(
                        street: RandomUserLocation.RandomUserStreet(number: 123, name: "Main St"),
                        city: "Springfield",
                        state: "IL",
                        country: "United States",
                        postcode: .string("62701")
                    ),
                    dob: RandomUserDob(date: "1990-05-15T10:30:00.000Z", age: 35),
                    phone: "(555) 123-4567",
                    cell: "(555) 987-6543",
                    picture: RandomUserPicture(
                        large: "https://randomuser.me/api/portraits/men/1.jpg",
                        medium: "https://randomuser.me/api/portraits/med/men/1.jpg",
                        thumbnail: "https://randomuser.me/api/portraits/thumb/men/1.jpg"
                    ),
                    nat: "US"
                )
            ]
        )
    }
}
