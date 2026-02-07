import XCTest
@testable import dogCatAndI

final class DogsInteractorTests: XCTestCase {

    var sut: DogsInteractor!
    var mockPresenter: MockDogsPresenter!
    var mockWorker: MockDogsWorker!

    override func setUp() {
        super.setUp()
        mockPresenter = MockDogsPresenter()
        mockWorker = MockDogsWorker()
        sut = DogsInteractor(presenter: mockPresenter, worker: mockWorker)
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockWorker = nil
        super.tearDown()
    }

    // MARK: - Concurrent Fetch Tests

    func testFetchDogsConcurrently_callsWorkerThreeTimes() {
        let expectation = XCTestExpectation(description: "Concurrent fetch completes")

        sut.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .concurrent))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockWorker.fetchCallCount, 3)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchDogsConcurrently_presentsThreeDogs() {
        let expectation = XCTestExpectation(description: "Presents dogs")

        sut.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .concurrent))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockPresenter.presentDogsCallCount, 1)
            XCTAssertEqual(self.mockPresenter.lastDogsResponse?.dogImages.count, 3)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchDogsConcurrently_showsAndHidesLoading() {
        let expectation = XCTestExpectation(description: "Loading states")

        sut.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .concurrent))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.mockPresenter.loadingStates.contains(true))
            XCTAssertTrue(self.mockPresenter.loadingStates.contains(false))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchDogsConcurrently_correctImageIndices() {
        let expectation = XCTestExpectation(description: "Correct indices")

        sut.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .concurrent))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let indices = self.mockPresenter.lastDogsResponse?.dogImages.map { $0.index }.sorted()
            XCTAssertEqual(indices, [0, 1, 2])
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    // MARK: - Sequential Fetch Tests

    func testFetchDogsSequentially_callsWorkerThreeTimes() {
        let expectation = XCTestExpectation(description: "Sequential fetch completes")

        sut.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .sequential))

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            XCTAssertEqual(self.mockWorker.fetchCallCount, 3)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 15)
    }

    // MARK: - Error Handling

    func testFetchDogs_workerError_stillPresentsResponse() {
        mockWorker.mockError = NetworkError.invalidResponse
        let expectation = XCTestExpectation(description: "Error handling")

        sut.fetchDogs(request: Dogs.FetchDogs.Request(loadType: .concurrent))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockPresenter.presentDogsCallCount, 1)
            XCTAssertEqual(self.mockPresenter.lastDogsResponse?.dogImages.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}
