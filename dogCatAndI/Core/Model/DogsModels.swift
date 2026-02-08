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
        }

        struct ViewModel {
            struct DogItem: Identifiable, Equatable {
                let id: Int
                let imageURL: URL?
                let label: String
            }
            let dogs: [DogItem]
        }
    }
}

// MARK: - Dog API Response
struct DogAPIResponseModel {
    private(set) var message: String

    init(message: String = "") {
        self.message = message
    }
}

extension DogAPIResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.message = (try map.decodeIfPresent(String?.self, forKey: .message) ?? "") ?? ""
        } catch {
            self = Self()
        }
    }
}
