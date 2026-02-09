//
//  CatsModels.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation
import OrderedCollections

// MARK: - Cats Use Cases
enum Cats {
    enum FetchBreeds {
        struct Request {
            let page: Int
        }

        struct Response {
            let breeds: [CatBreed]
        }

        struct ViewModel {
            struct BreedItem: Identifiable, Equatable {
                let id: String
                let breed: String
                let country: String
                let origin: String
                let coat: String
                let pattern: String
            }
            var breeds: OrderedDictionary<String, BreedItem> = [:]
        }
    }
}

// MARK: - Cat API Response
struct CatBreedsAPIResponse {
    private(set) var currentPage: Int?
    private(set) var data: [CatBreed] = []
    private(set) var nextPageURL: String?
}

extension CatBreedsAPIResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case nextPageURL = "next_page_url"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.currentPage = (try map.decodeIfPresent(Int?.self, forKey: .currentPage) ?? 0) ?? 0
            self.data = (try map.decodeIfPresent([CatBreed]?.self, forKey: .data) ?? []) ?? []
            self.nextPageURL = (try map.decodeIfPresent(String?.self, forKey: .nextPageURL) ?? "") ?? ""
        } catch {
            self = Self()
        }
    }
}

struct CatBreed: Identifiable {
    private(set) var breed: String = ""
    private(set) var country: String = ""
    private(set) var origin: String = ""
    private(set) var coat: String = ""
    private(set) var pattern: String = ""

    var id: String { breed }
}

extension CatBreed: Codable {
    enum CodingKeys: String, CodingKey {
        case breed = "breed"
        case country = "country"
        case origin = "origin"
        case coat = "coat"
        case pattern = "pattern"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.breed = (try map.decodeIfPresent(String?.self, forKey: .breed) ?? "") ?? ""
            self.country = (try map.decodeIfPresent(String?.self, forKey: .country) ?? "") ?? ""
            self.origin = (try map.decodeIfPresent(String?.self, forKey: .origin) ?? "") ?? ""
            self.coat = (try map.decodeIfPresent(String?.self, forKey: .coat) ?? "") ?? ""
            self.pattern = (try map.decodeIfPresent(String?.self, forKey: .pattern) ?? "") ?? ""
        } catch {
            self = Self()
        }
    }
}
