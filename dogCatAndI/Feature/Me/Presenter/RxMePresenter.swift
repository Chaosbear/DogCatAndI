//
//  RxMePresenter.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 12/2/2569 BE.
//

import UIKit
import RxSwift
import RxCocoa

class RxMeViewState {
    let profile = BehaviorRelay<Me.FetchProfile.ViewModel?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorState = BehaviorRelay<ErrorViewStateModel>(value: .noError)
}

final class RxMePresenter: MePresentationLogic {
    let viewState: RxMeViewState

    init(viewState: RxMeViewState) {
        self.viewState = viewState
    }

    func presentProfile(response: Me.FetchProfile.Response) {
        guard let user = response.user else {
            viewState.profile.accept(nil)
            return
        }

        let dobString = Utils.dateFormat(from: user.dob.date, format: .custom("dd/MM/yyyy")) ?? user.dob.date

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
        viewState.profile.accept(viewModel)
    }

    func presentLoading(_ isLoading: Bool) {
        viewState.isLoading.accept(isLoading)
    }

    func presentErrorState(_ state: ErrorViewStateModel) {
        viewState.errorState.accept(state)
    }
}
