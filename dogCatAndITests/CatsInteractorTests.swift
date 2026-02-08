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

        Task { await sut.fetchBreeds() }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockWorker.fetchCallCount, 1)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchBreeds_presentsBreeds() {
        let expectation = XCTestExpectation(description: "Presents breeds")

        Task { await sut.fetchBreeds() }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockPresenter.presentBreedsCallCount, 1)
            XCTAssertEqual(self.mockPresenter.lastBreedsResponse?.breeds.count, 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchBreeds_showsAndHidesLoading() {
        let expectation = XCTestExpectation(description: "Loading states")

        Task { await sut.fetchBreeds() }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.mockPresenter.loadingStates.contains(true))
            XCTAssertTrue(self.mockPresenter.loadingStates.contains(false))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchBreeds_workerError_presentsErrorState() {
        mockWorker.mockError = NetworkError.serverError(500)
        let expectation = XCTestExpectation(description: "Error handling")

        Task { await sut.fetchBreeds() }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockPresenter.presentBreedsCallCount, 0)
            XCTAssertEqual(self.mockPresenter.presentErrorStateCallCount, 1)
            XCTAssertEqual(self.mockPresenter.errorStates.last, .systemError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}
