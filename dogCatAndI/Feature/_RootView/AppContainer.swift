//
//  AppContainer.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation
import Combine

// MARK: - App Container
// Wires up all components (Dependency Injection Container)
final class AppContainer: ObservableObject {
    // Dogs Scene
    let dogsViewState: DogsViewState
    let dogsInteractor: DogsBusinessLogic

    // Cats Scene
    let catsViewState: CatsViewState
    let catsInteractor: CatsBusinessLogic

    // Me Scene
    let meViewState: MeViewState
    let meInteractor: MeBusinessLogic

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        // Configure Dogs Scene
        let dogsViewState = DogsViewState()
        let dogsPresenter = DogsPresenter(viewState: dogsViewState)
        let dogsWorker = DogsWorker(networkService: networkService)
        let dogsInteractor = DogsInteractor(presenter: dogsPresenter, worker: dogsWorker)
        self.dogsViewState = dogsViewState
        self.dogsInteractor = dogsInteractor

        // Configure Cats Scene
        let catsViewState = CatsViewState()
        let catsPresenter = CatsPresenter(viewState: catsViewState)
        let catsWorker = CatsWorker(networkService: networkService)
        let catsInteractor = CatsInteractor(presenter: catsPresenter, worker: catsWorker)
        self.catsViewState = catsViewState
        self.catsInteractor = catsInteractor

        // Configure Me Scene
        let meViewState = MeViewState()
        let mePresenter = MePresenter(viewState: meViewState)
        let meWorker = MeWorker(networkService: networkService)
        let meInteractor = MeInteractor(presenter: mePresenter, worker: meWorker)
        self.meViewState = meViewState
        self.meInteractor = meInteractor
    }
}

final class RxAppContainer {
    let dogsViewController: RxDogsViewController
    let catsViewController: RxCatsViewController
    let meViewController: RxMeViewController

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        // Configure Dogs Scene
        let dogsViewState = RxDogsViewState()
        let dogsPresenter = RxDogsPresenter(viewState: dogsViewState)
        let dogsWorker = DogsWorker(networkService: networkService)
        let dogsInteractor = DogsInteractor(presenter: dogsPresenter, worker: dogsWorker)
        dogsViewController = RxDogsViewController(viewState: dogsViewState, interactor: dogsInteractor)

        // Configure Cats Scene
        let catsViewState = RxCatsViewState()
        let catsPresenter = RxCatsPresenter(viewState: catsViewState)
        let catsWorker = CatsWorker(networkService: networkService)
        let catsInteractor = CatsInteractor(presenter: catsPresenter, worker: catsWorker)
        catsViewController = RxCatsViewController(viewState: catsViewState, interactor: catsInteractor)

        // Configure Me Scene
        let meViewState = RxMeViewState()
        let mePresenter = RxMePresenter(viewState: meViewState)
        let meWorker = MeWorker(networkService: networkService)
        let meInteractor = MeInteractor(presenter: mePresenter, worker: meWorker)
        meViewController = RxMeViewController(viewState: meViewState, interactor: meInteractor)
    }
}
