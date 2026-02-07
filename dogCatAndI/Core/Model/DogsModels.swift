//
//  DogsModels.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Dogs Use Cases
enum Dogs {
    enum FetchDogs {
        struct Request {
            enum LoadType {
                case concurrent
                case sequential
            }
            let loadType: LoadType
        }

        struct Response {
            struct DogImage {
                let imageURL: String
                let timestamp: Date
                let index: Int
            }
            let dogImages: [DogImage]
            let error: String?
        }

        struct ViewModel {
            struct DogItem: Identifiable {
                let id: Int
                let imageURL: URL?
                let label: String
            }
            let dogs: [DogItem]
        }
    }
}

// MARK: - Dog API Response
struct DogAPIResponse: Decodable {
    let message: String
    let status: String
}
