import XCTest
@testable import dogCatAndI

final class CatsInteractorTests: XCTestCase {

    var sut: CatsInteractor!
    var mockPresenter: MockCatsPresenter!
    var mockWorker: MockCatsWorker!

    override func setUp() {
        super.setUp()
        mockPresenter = MockCatsPresenter()
        mockWorker = MockCatsWorker()
        sut = CatsInteractor(presenter: mockPresenter, worker: mockWorker)
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockWorker = nil
        super.tearDown()
    }

    func testFetchBreeds_callsWorker() {
        let expectation = XCTestExpectation(description: "Fetch breeds")

        sut.fetchBreeds(request: Cats.FetchBreeds.Request())

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockWorker.fetchCallCount, 1)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchBreeds_presentsBreeds() {
        let expectation = XCTestExpectation(description: "Presents breeds")

        sut.fetchBreeds(request: Cats.FetchBreeds.Request())

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockPresenter.presentBreedsCallCount, 1)
            XCTAssertEqual(self.mockPresenter.lastBreedsResponse?.breeds.count, 2)
            XCTAssertNil(self.mockPresenter.lastBreedsResponse?.error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchBreeds_showsAndHidesLoading() {
        let expectation = XCTestExpectation(description: "Loading states")

        sut.fetchBreeds(request: Cats.FetchBreeds.Request())

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.mockPresenter.loadingStates.contains(true))
            XCTAssertTrue(self.mockPresenter.loadingStates.contains(false))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchBreeds_workerError_presentsError() {
        mockWorker.mockError = NetworkError.invalidResponse
        let expectation = XCTestExpectation(description: "Error handling")

        sut.fetchBreeds(request: Cats.FetchBreeds.Request())

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockPresenter.presentBreedsCallCount, 1)
            XCTAssertNotNil(self.mockPresenter.lastBreedsResponse?.error)
            XCTAssertEqual(self.mockPresenter.lastBreedsResponse?.breeds.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}
