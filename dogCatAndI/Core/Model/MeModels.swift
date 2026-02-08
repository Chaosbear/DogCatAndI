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
struct RandomUserAPIResponse {
    private(set) var results: [RandomUserResult] = []
}

extension RandomUserAPIResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.results = (try map.decodeIfPresent([RandomUserResult]?.self, forKey: .results) ?? []) ?? []
        } catch {
            self = Self()
        }
    }
}

struct RandomUserResult {
    private(set) var gender: String = ""
    private(set) var name: RandomUserName = .init()
    private(set) var location: RandomUserLocation = .init()
    private(set) var dob: RandomUserDOB = .init()
    private(set) var phone: String = ""
    private(set) var cell: String = ""
    private(set) var picture: RandomUserPicture = .init()
    private(set) var nat: String = ""
}

extension RandomUserResult: Codable {
    enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case name = "name"
        case location = "location"
        case dob = "dob"
        case phone = "phone"
        case cell = "cell"
        case picture = "picture"
        case nat = "nat"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.gender = (try map.decodeIfPresent(String?.self, forKey: .gender) ?? "") ?? ""
            self.name = (try map.decodeIfPresent(RandomUserName?.self, forKey: .name) ?? .init()) ?? .init()
            self.location = (try map.decodeIfPresent(RandomUserLocation?.self, forKey: .location) ?? .init()) ?? .init()
            self.dob = (try map.decodeIfPresent(RandomUserDOB?.self, forKey: .dob) ?? .init()) ?? .init()
            self.phone = (try map.decodeIfPresent(String?.self, forKey: .phone) ?? "") ?? ""
            self.cell = (try map.decodeIfPresent(String?.self, forKey: .cell) ?? "") ?? ""
            self.picture = (try map.decodeIfPresent(RandomUserPicture?.self, forKey: .picture) ?? .init()) ?? .init()
            self.nat = (try map.decodeIfPresent(String?.self, forKey: .nat) ?? "") ?? ""
        } catch {
            self = Self()
        }
    }
}

struct RandomUserName {
    private(set) var title: String = ""
    private(set) var first: String = ""
    private(set) var last: String = ""
}

extension RandomUserName: Codable {
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case first = "first"
        case last = "last"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.title = (try map.decodeIfPresent(String?.self, forKey: .title) ?? "") ?? ""
            self.first = (try map.decodeIfPresent(String?.self, forKey: .first) ?? "") ?? ""
            self.last = (try map.decodeIfPresent(String?.self, forKey: .last) ?? "") ?? ""
        } catch {
            self = Self()
        }
    }
}

struct RandomUserLocation {
    private(set) var street: RandomUserStreet = .init()
    private(set) var city: String = ""
    private(set) var state: String = ""
    private(set) var country: String = ""
    private(set) var postcode: String = ""
}

extension RandomUserLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case street = "street"
        case city = "city"
        case state = "state"
        case country = "country"
        case postcode = "postcode"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.street = (try map.decodeIfPresent(RandomUserStreet?.self, forKey: .street) ?? .init()) ?? .init()
            self.city = (try map.decodeIfPresent(String?.self, forKey: .city) ?? "") ?? ""
            self.state = (try map.decodeIfPresent(String?.self, forKey: .state) ?? "") ?? ""
            self.country = (try map.decodeIfPresent(String?.self, forKey: .country) ?? "") ?? ""
            if let intValue = try map.decodeIfPresent(Int.self, forKey: .postcode) {
                self.postcode = String(intValue)
            } else if let stringValue = try map.decodeIfPresent(String.self, forKey: .postcode) {
                self.postcode = stringValue
            } else {
                self.postcode = ""
            }
        } catch {
            self = Self()
        }
    }
}

struct RandomUserStreet {
    private(set) var number: Int = 0
    private(set) var name: String = ""
}

extension RandomUserStreet: Codable {
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.number = (try map.decodeIfPresent(Int?.self, forKey: .number) ?? 0) ?? 0
            self.name = (try map.decodeIfPresent(String?.self, forKey: .name) ?? "") ?? ""
        } catch {
            self = Self()
        }
    }
}

struct RandomUserDOB {
    private(set) var date: String = ""
    private(set) var age: Int = 0
}

extension RandomUserDOB: Codable {
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case age = "age"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.date = (try map.decodeIfPresent(String?.self, forKey: .date) ?? "") ?? ""
            self.age = (try map.decodeIfPresent(Int?.self, forKey: .age) ?? 0) ?? 0
        } catch {
            self = Self()
        }
    }
}

struct RandomUserPicture {
    private(set) var large: String = ""
}

extension RandomUserPicture: Codable {
    enum CodingKeys: String, CodingKey {
        case large = "large"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.large = (try map.decodeIfPresent(String?.self, forKey: .large) ?? "") ?? ""
        } catch {
            self = Self()
        }
    }
}
