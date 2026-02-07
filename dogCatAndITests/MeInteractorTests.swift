import XCTest
@testable import dogCatAndI

final class MeInteractorTests: XCTestCase {

    var sut: MeInteractor!
    var mockPresenter: MockMePresenter!
    var mockWorker: MockMeWorker!

    override func setUp() {
        super.setUp()
        mockPresenter = MockMePresenter()
        mockWorker = MockMeWorker()
        sut = MeInteractor(presenter: mockPresenter, worker: mockWorker)
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockWorker = nil
        super.tearDown()
    }

    func testFetchProfile_callsWorker() {
        let expectation = XCTestExpectation(description: "Fetch profile")

        sut.fetchProfile(request: Me.FetchProfile.Request())

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockWorker.fetchCallCount, 1)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchProfile_presentsProfile() {
        let expectation = XCTestExpectation(description: "Presents profile")

        sut.fetchProfile(request: Me.FetchProfile.Request())

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockPresenter.presentProfileCallCount, 1)
            XCTAssertNotNil(self.mockPresenter.lastProfileResponse?.user)
            XCTAssertNil(self.mockPresenter.lastProfileResponse?.error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchProfile_showsAndHidesLoading() {
        let expectation = XCTestExpectation(description: "Loading states")

        sut.fetchProfile(request: Me.FetchProfile.Request())

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.mockPresenter.loadingStates.contains(true))
            XCTAssertTrue(self.mockPresenter.loadingStates.contains(false))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testFetchProfile_workerError_presentsError() {
        mockWorker.mockError = NetworkError.invalidResponse
        let expectation = XCTestExpectation(description: "Error handling")

        sut.fetchProfile(request: Me.FetchProfile.Request())

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockPresenter.presentProfileCallCount, 1)
            XCTAssertNil(self.mockPresenter.lastProfileResponse?.user)
            XCTAssertNotNil(self.mockPresenter.lastProfileResponse?.error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}
