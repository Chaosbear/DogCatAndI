//
//  MeModels.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Me Use Cases

enum Me {
    enum FetchProfile {
        struct Request {}

        struct Response {
            let user: RandomUserResult?
            let error: String?
        }

        struct ViewModel {
            let profileImageURL: URL?
            let title: String
            let firstName: String
            let lastName: String
            let dateOfBirth: String
            let age: String
            let gender: String
            let nationality: String
            let mobile: String
            let address: String
        }
    }
}

// MARK: - Random User API Response

struct RandomUserAPIResponse: Decodable {
    let results: [RandomUserResult]
}

struct RandomUserResult: Decodable {
    let gender: String
    let name: RandomUserName
    let location: RandomUserLocation
    let dob: RandomUserDob
    let phone: String
    let cell: String
    let picture: RandomUserPicture
    let nat: String
}

struct RandomUserName: Decodable {
    let title: String
    let first: String
    let last: String
}

struct RandomUserLocation: Decodable {
    let street: RandomUserStreet
    let city: String
    let state: String
    let country: String
    let postcode: PostcodeValue

    struct RandomUserStreet: Decodable {
        let number: Int
        let name: String
    }
}

enum PostcodeValue: Decodable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            self = .string("")
        }
    }

    var stringValue: String {
        switch self {
        case .string(let value): return value
        case .int(let value): return String(value)
        }
    }
}

struct RandomUserDob: Decodable {
    let date: String
    let age: Int
}

struct RandomUserPicture: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}
