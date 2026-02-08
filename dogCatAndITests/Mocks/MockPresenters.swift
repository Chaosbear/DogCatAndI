import Foundation
@testable import dogCatAndI

// MARK: - Mock Dogs Presenter

class MockDogsPresenter: DogsPresentationLogic {
    var presentDogsCallCount = 0
    var presentLoadingCallCount = 0
    var presentErrorStateCallCount = 0
    var lastDogsResponse: Dogs.FetchDogs.Response?
    var loadingStates: [Bool] = []
    var errorStates: [ErrorViewStateModel] = []
    var lastLoadType: Dogs.FetchDogs.Request.LoadType?

    func presentDogs(response: Dogs.FetchDogs.Response) {
        presentDogsCallCount += 1
        lastDogsResponse = response
    }

    func presentLoading(_ isLoading: Bool) {
        presentLoadingCallCount += 1
        loadingStates.append(isLoading)
    }

    func presentErrorState(_ state: ErrorViewStateModel) {
        presentErrorStateCallCount += 1
        errorStates.append(state)
    }

    func setCurrentLoadType(loadType: Dogs.FetchDogs.Request.LoadType) {
        lastLoadType = loadType
    }
}

// MARK: - Mock Cats Presenter

class MockCatsPresenter: CatsPresentationLogic {
    var presentBreedsCallCount = 0
    var presentLoadingCallCount = 0
    var presentErrorStateCallCount = 0
    var lastBreedsResponse: Cats.FetchBreeds.Response?
    var lastIsReplace: Bool?
    var loadingStates: [Bool] = []
    var errorStates: [ErrorViewStateModel] = []

    func presentBreeds(response: Cats.FetchBreeds.Response, isReplace: Bool) {
        presentBreedsCallCount += 1
        lastBreedsResponse = response
        lastIsReplace = isReplace
    }

    func presentLoading(_ isLoading: Bool) {
        presentLoadingCallCount += 1
        loadingStates.append(isLoading)
    }

    func presentErrorState(_ state: ErrorViewStateModel) {
        presentErrorStateCallCount += 1
        errorStates.append(state)
    }
}

// MARK: - Mock Me Presenter

class MockMePresenter: MePresentationLogic {
    var presentProfileCallCount = 0
    var presentLoadingCallCount = 0
    var presentErrorStateCallCount = 0
    var lastProfileResponse: Me.FetchProfile.Response?
    var loadingStates: [Bool] = []
    var errorStates: [ErrorViewStateModel] = []

    func presentProfile(response: Me.FetchProfile.Response) {
        presentProfileCallCount += 1
        lastProfileResponse = response
    }

    func presentLoading(_ isLoading: Bool) {
        presentLoadingCallCount += 1
        loadingStates.append(isLoading)
    }

    func presentErrorState(_ state: ErrorViewStateModel) {
        presentErrorStateCallCount += 1
        errorStates.append(state)
    }
}
