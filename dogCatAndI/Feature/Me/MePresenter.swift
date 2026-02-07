//
//  MePresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

// MARK: - Me Presentation Logic

protocol MePresentationLogic: AnyObject {
    func presentProfile(response: Me.FetchProfile.Response)
    func presentLoading(_ isLoading: Bool)
}

// MARK: - Me Presenter

class MePresenter: MePresentationLogic {
    weak var store: MeStore?

    private let dobInputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()

    private let dobOutputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    init(store: MeStore) {
        self.store = store
    }

    func presentProfile(response: Me.FetchProfile.Response) {
        guard let user = response.user else {
            DispatchQueue.main.async { [weak self] in
                self?.store?.errorMessage = response.error ?? "Failed to load profile"
            }
            return
        }

        // Format date of birth
        var dobString = ""
        if let dobDate = dobInputFormatter.date(from: user.dob.date) {
            dobString = dobOutputFormatter.string(from: dobDate)
        } else {
            // Fallback: try without fractional seconds
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
            fallbackFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let dobDate = fallbackFormatter.date(from: user.dob.date) {
                dobString = dobOutputFormatter.string(from: dobDate)
            } else {
                dobString = user.dob.date
            }
        }

        // Format address
        let location = user.location
        let streetAddress = "\(location.street.number) \(location.street.name)"
        let cityState = "\(location.city), \(location.state)"
        let countryPostcode = "\(location.country) \(location.postcode.stringValue)"
        let fullAddress = "\(streetAddress)\n\(cityState)\n\(countryPostcode)"

        let viewModel = Me.FetchProfile.ViewModel(
            profileImageURL: URL(string: user.picture.large),
            title: user.name.title,
            firstName: user.name.first,
            lastName: user.name.last,
            dateOfBirth: dobString,
            age: String(user.dob.age),
            gender: user.gender,
            nationality: user.nat,
            mobile: user.cell,
            address: fullAddress
        )

        DispatchQueue.main.async { [weak self] in
            self?.store?.profile = viewModel
            self?.store?.errorMessage = nil
        }
    }

    func presentLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.store?.isLoading = isLoading
        }
    }
}
