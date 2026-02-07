//
//  CatsModels.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Cats Use Cases

enum Cats {
    enum FetchBreeds {
        struct Request {}

        struct Response {
            let breeds: [CatBreed]
            let error: String?
        }

        struct ViewModel {
            struct BreedItem: Identifiable {
                let id: String
                let breed: String
                let country: String
                let origin: String
                let coat: String
                let pattern: String
            }
            let breeds: [BreedItem]
        }
    }
}

// MARK: - Cat API Response

struct CatBreedsAPIResponse: Decodable {
    let currentPage: Int?
    let data: [CatBreed]
    let lastPage: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case lastPage = "last_page"
        case total
    }
}

struct CatBreed: Decodable, Identifiable {
    let breed: String
    let country: String
    let origin: String
    let coat: String
    let pattern: String

    var id: String { breed }
}
