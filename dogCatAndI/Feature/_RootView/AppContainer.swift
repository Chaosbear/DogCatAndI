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
class AppContainer: ObservableObject {
    // Dogs Scene
//    let dogsStore: DogsViewState
//    let dogsInteractor: DogsBusinessLogic
//
//    // Cats Scene
//    let catsStore: CatsStore
//    let catsInteractor: CatsBusinessLogic
//
//    // Me Scene
//    let meStore: MeStore
//    let meInteractor: MeBusinessLogic
//
//    init(networkService: NetworkServiceProtocol = NetworkService()) {
//        // Configure Dogs Scene
//        let dogsStore = DogsViewState()
//        let dogsPresenter = DogsPresenter(store: dogsStore)
//        let dogsWorker = DogsWorker(networkService: networkService)
//        let dogsInteractor = DogsInteractor(presenter: dogsPresenter, worker: dogsWorker)
//        self.dogsStore = dogsStore
//        self.dogsInteractor = dogsInteractor
//
//        // Configure Cats Scene
//        let catsStore = CatsStore()
//        let catsPresenter = CatsPresenter(store: catsStore)
//        let catsWorker = CatsWorker(networkService: networkService)
//        let catsInteractor = CatsInteractor(presenter: catsPresenter, worker: catsWorker)
//        self.catsStore = catsStore
//        self.catsInteractor = catsInteractor
//
//        // Configure Me Scene
//        let meStore = MeStore()
//        let mePresenter = MePresenter(store: meStore)
//        let meWorker = MeWorker(networkService: networkService)
//        let meInteractor = MeInteractor(presenter: mePresenter, worker: meWorker)
//        self.meStore = meStore
//        self.meInteractor = meInteractor
//    }
}
