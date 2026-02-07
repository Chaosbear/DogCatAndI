import XCTest
@testable import dogCatAndI

final class CatsPresenterTests: XCTestCase {

    var sut: CatsPresenter!
    var store: CatsStore!

    override func setUp() {
        super.setUp()
        store = CatsStore()
        sut = CatsPresenter(store: store)
    }

    override func tearDown() {
        sut = nil
        store = nil
        super.tearDown()
    }

    func testPresentBreeds_mapsCorrectly() {
        let breeds = [
            CatBreed(breed: "Persian", country: "Iran", origin: "Natural", coat: "Long", pattern: "Solid"),
            CatBreed(breed: "Siamese", country: "Thailand", origin: "Natural", coat: "Short", pattern: "Colorpoint")
        ]

        let response = Cats.FetchBreeds.Response(breeds: breeds, error: nil)
        sut.presentBreeds(response: response)

        let expectation = XCTestExpectation(description: "Store updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.store.breeds.count, 2)
            XCTAssertEqual(self.store.breeds[0].breed, "Persian")
            XCTAssertEqual(self.store.breeds[0].country, "Iran")
            XCTAssertEqual(self.store.breeds[1].breed, "Siamese")
            XCTAssertEqual(self.store.breeds[1].coat, "Short")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testPresentBreeds_emptyList() {
        let response = Cats.FetchBreeds.Response(breeds: [], error: nil)
        sut.presentBreeds(response: response)

        let expectation = XCTestExpectation(description: "Store updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.store.breeds.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testPresentLoading_updatesStore() {
        sut.presentLoading(true)

        let expectation = XCTestExpectation(description: "Loading updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.store.isLoading)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
}
