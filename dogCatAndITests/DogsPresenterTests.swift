import XCTest
@testable import dogCatAndI

final class DogsPresenterTests: XCTestCase {

    var sut: DogsPresenter!
    var store: DogsViewState!

    override func setUp() {
        super.setUp()
        store = DogsViewState()
        sut = DogsPresenter(store: store)
    }

    override func tearDown() {
        sut = nil
        store = nil
        super.tearDown()
    }

    func testPresentDogs_formatsLabelsCorrectly() {
        let fixedDate = DateComponents(
            calendar: Calendar.current,
            year: 2025, month: 1, day: 15,
            hour: 14, minute: 30, second: 45
        ).date!

        let response = Dogs.FetchDogs.Response(
            dogImages: [
                Dogs.FetchDogs.Response.DogImage(
                    imageURL: "https://example.com/dog1.jpg",
                    timestamp: fixedDate,
                    index: 0
                )
            ],
            error: nil
        )

        sut.presentDogs(response: response)

        let expectation = XCTestExpectation(description: "Store updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.store.dogs.count, 1)
            XCTAssertTrue(self.store.dogs[0].label.hasPrefix("Dog#1 @ 2025-01-15"))
            XCTAssertNotNil(self.store.dogs[0].imageURL)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testPresentDogs_multipleImages_correctOrder() {
        let date = Date()
        let response = Dogs.FetchDogs.Response(
            dogImages: [
                Dogs.FetchDogs.Response.DogImage(imageURL: "https://example.com/1.jpg", timestamp: date, index: 0),
                Dogs.FetchDogs.Response.DogImage(imageURL: "https://example.com/2.jpg", timestamp: date, index: 1),
                Dogs.FetchDogs.Response.DogImage(imageURL: "https://example.com/3.jpg", timestamp: date, index: 2)
            ],
            error: nil
        )

        sut.presentDogs(response: response)

        let expectation = XCTestExpectation(description: "Store updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.store.dogs.count, 3)
            XCTAssertTrue(self.store.dogs[0].label.contains("Dog#1"))
            XCTAssertTrue(self.store.dogs[1].label.contains("Dog#2"))
            XCTAssertTrue(self.store.dogs[2].label.contains("Dog#3"))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testPresentLoading_updatesStore() {
        sut.presentLoading(true)

        let expectation = XCTestExpectation(description: "Loading updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.store.isLoading)
            self.sut.presentLoading(false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XCTAssertFalse(self.store.isLoading)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3)
    }
}
