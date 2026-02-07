import Foundation
@testable import dogCatAndI

// MARK: - Mock Dogs Presenter

class MockDogsPresenter: DogsPresentationLogic {
    var presentDogsCallCount = 0
    var presentLoadingCallCount = 0
    var lastDogsResponse: Dogs.FetchDogs.Response?
    var loadingStates: [Bool] = []

    func presentDogs(response: Dogs.FetchDogs.Response) {
        presentDogsCallCount += 1
        lastDogsResponse = response
    }

    func presentLoading(_ isLoading: Bool) {
        presentLoadingCallCount += 1
        loadingStates.append(isLoading)
    }
}

// MARK: - Mock Cats Presenter

class MockCatsPresenter: CatsPresentationLogic {
    var presentBreedsCallCount = 0
    var presentLoadingCallCount = 0
    var lastBreedsResponse: Cats.FetchBreeds.Response?
    var loadingStates: [Bool] = []

    func presentBreeds(response: Cats.FetchBreeds.Response) {
        presentBreedsCallCount += 1
        lastBreedsResponse = response
    }

    func presentLoading(_ isLoading: Bool) {
        presentLoadingCallCount += 1
        loadingStates.append(isLoading)
    }
}

// MARK: - Mock Me Presenter

class MockMePresenter: MePresentationLogic {
    var presentProfileCallCount = 0
    var presentLoadingCallCount = 0
    var lastProfileResponse: Me.FetchProfile.Response?
    var loadingStates: [Bool] = []

    func presentProfile(response: Me.FetchProfile.Response) {
        presentProfileCallCount += 1
        lastProfileResponse = response
    }

    func presentLoading(_ isLoading: Bool) {
        presentLoadingCallCount += 1
        loadingStates.append(isLoading)
    }
}
