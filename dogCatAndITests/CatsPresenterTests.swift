import XCTest
import OrderedCollections
@testable import dogCatAndI

@MainActor
final class CatsPresenterTests: XCTestCase {

    var sut: CatsPresenter!
    var store: CatsViewState!

    override func setUp() {
        super.setUp()
        store = CatsViewState()
        sut = CatsPresenter(viewState: store)
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

        let response = Cats.FetchBreeds.Response(breeds: breeds)
        sut.presentBreeds(response: response, isReplace: true)

        let expectation = XCTestExpectation(description: "Store updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.store.breeds.count, 2)
            XCTAssertEqual(self.store.breeds["Persian"]?.breed, "Persian")
            XCTAssertEqual(self.store.breeds["Persian"]?.country, "Iran")
            XCTAssertEqual(self.store.breeds["Siamese"]?.breed, "Siamese")
            XCTAssertEqual(self.store.breeds["Siamese"]?.coat, "Short")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testPresentBreeds_emptyList() {
        let response = Cats.FetchBreeds.Response(breeds: [])
        sut.presentBreeds(response: response, isReplace: true)

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
