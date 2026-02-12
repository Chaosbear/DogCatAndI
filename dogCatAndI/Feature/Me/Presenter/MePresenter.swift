//
//  MePresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import Foundation

protocol MePresentationLogic: AnyObject {
    func presentProfile(response: Me.FetchProfile.Response)
    func presentLoading(_ isLoading: Bool)
    func presentErrorState(_ state: ErrorViewStateModel)
}

class MePresenter: MePresentationLogic {
    weak var viewState: MeViewState?

    init(viewState: MeViewState) {
        self.viewState = viewState
    }

    func presentProfile(response: Me.FetchProfile.Response) {
        guard let user = response.user else {
            viewState?.profile = nil
            return
        }

        // Format date of birth
        let dobString = Utils.dateFormat(from: user.dob.date, format: .custom("dd/MM/yyyy")) ?? user.dob.date

        // Format address
        let location = user.location


        var streetAddress = "\(location.street.number)"
        if !location.street.name.isEmpty {
            streetAddress += "  \(location.street.name)"
        }
        var cityState = ""
        if !location.city.isEmpty {
            cityState += location.city
        }
        if !location.state.isEmpty {
            cityState += ",  \(location.state)"
        }
        var countryPostcode = ""
        if !location.country.isEmpty {
            countryPostcode += location.country
        }
        if !location.postcode.isEmpty {
            cityState += "  \(location.postcode)"
        }

        var fullAddress = "\(streetAddress)\n\(cityState)\n\(countryPostcode)"
        if !cityState.isEmpty {
            fullAddress += "\n\(cityState)"
        }
        if !countryPostcode.isEmpty {
            fullAddress += "\n\(countryPostcode)"
        }

        let viewModel = Me.FetchProfile.ViewModel(
            profileImageURL: URL(string: user.picture.large),
            title: user.name.title.withPlaceholder(),
            firstName: user.name.first.withPlaceholder(),
            lastName: user.name.last.withPlaceholder(),
            dateOfBirth: dobString,
            age: String(user.dob.age),
            gender: user.gender,
            nationality: user.nat.withPlaceholder(),
            mobile: user.cell.withPlaceholder(),
            address: fullAddress.withPlaceholder()
        )
        viewState?.profile = viewModel
    }

    func presentLoading(_ isLoading: Bool) {
        if viewState?.isLoading != isLoading {
            viewState?.isLoading = isLoading
        }
    }

    func presentErrorState(_ state: ErrorViewStateModel) {
        if viewState?.errorState != state {
            viewState?.errorState = state
        }
    }
}
