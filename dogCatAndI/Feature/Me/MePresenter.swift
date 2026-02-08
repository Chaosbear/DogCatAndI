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
    func presentErrorState(_ state: ErrorViewStateModel)
}

// MARK: - Me Presenter

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
        var dobString = Utils.dateFormat(from: user.dob.date, format: .custom("dd/MM/yyyy")) ?? user.dob.date

        // Format address
        let location = user.location
        let streetAddress = "\(location.street.number) \(location.street.name)"
        let cityState = "\(location.city), \(location.state)"
        let countryPostcode = "\(location.country) \(location.postcode)"
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
