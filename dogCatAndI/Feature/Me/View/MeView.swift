//
//  MeView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import SwiftUI
import Combine

@MainActor
class MeViewState: ObservableObject {
    @Published var profile: Me.FetchProfile.ViewModel?
    @Published var isLoading = false
    @Published var errorState: ErrorViewStateModel = .noError
}

struct MeView: View {
    // MARK: - Property
    @Binding var selectedTab: RootView.MainTab

    // MARK: - Text Style
    private let titleTextStyle = TextStyler(
        font: DSFont.h1.font,
        color: Color(DSColor.black)
    )
    private let infoLabelTextStyle = TextStyler(
        font: DSFont.body1.font,
        color: Color(DSColor.gray1)
    )
    private let infoTextStyle = TextStyler(
        font: DSFont.body1.font,
        color: Color(DSColor.black)
    )
    private let buttonTextStyle = TextStyler(
        font: DSFont.body3.font,
        color: Color(DSColor.primaryWhite)
    )

    // MARK: - Layout
    private let sidePadding: CGFloat = 48

    // MARK: - Dependency
    @ObservedObject var viewState: MeViewState
    let interactor: MeBusinessLogic

    // MARK: - Init
    init(
        selectedTab: Binding<RootView.MainTab>,
        viewState: MeViewState,
        interactor: MeBusinessLogic
    ) {
        self._selectedTab = selectedTab
        self.viewState = viewState
        self.interactor = interactor
    }

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 0) {
            title
            ZStack {
                profileContent
                if viewState.isLoading && viewState.errorState == .noError {
                    profileSkeleton
                }
                if viewState.errorState != .noError {
                    errorView
                }
            }
            .frameExpand()
            reloadButton
        }
        .background(Color(DSColor.primaryWhite))
        .onViewDidLoad {
            if viewState.profile == nil && selectedTab == .me {
                interactor.fetchProfile()
            }
        }
        .onChange(of: selectedTab) { newTab in
            if newTab == .me && viewState.profile == nil {
                interactor.fetchProfile()
            }
        }
    }

    // MARK: - View Component
    @ViewBuilder
    private var title: some View {
        Text("Me")
            .modifier(titleTextStyle)
            .frameHorizontalExpand(alignment: .leading)
            .padding(.top, 12)
            .padding(.bottom, 6)
            .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var profileContent: some View {
        ScrollView {
            if let profile = viewState.profile {
                VStack(spacing: 24) {
                    profileImage(url: profile.profileImageURL)

                    // Profile Details
                    VStack(spacing: 12) {
                        profileRow(label: "Title", value: profile.title)
                        profileRow(label: "Firstname", value: profile.firstName)
                        profileRow(label: "Lastname", value: profile.lastName)
                        profileRow(label: "Date of Birth", value: profile.dateOfBirth)
                        profileRow(label: "Age", value: profile.age)
                        genderRow(gender: profile.gender)
                        profileRow(label: "Nationality", value: profile.nationality)
                        profileRow(label: "Mobile", value: profile.mobile)
                        addressRow(address: profile.address)
                    }
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, sidePadding)
            }
        }
    }

    @ViewBuilder
    private func profileImage(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty, .failure:
                Image("image_placeholder")
                    .resizable()
                    .scaledToFill()
                    .background(Color(.systemGray6))
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 160, height: 160)
        .clipShape(Circle())
    }

    @ViewBuilder
    private func profileRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label): ")
                .modifier(infoLabelTextStyle)
                .frame(width: 110, alignment: .leading)

            Text(value)
                .modifier(infoTextStyle)
        }
        .frameHorizontalExpand(alignment: .leading)
    }

    @ViewBuilder
    private func genderRow(gender: String) -> some View {
        HStack(alignment: .center) {
            Text("Gender: ")
                .modifier(infoLabelTextStyle)
                .frame(width: 110, alignment: .leading)

            Image(gender.lowercased() == "male" ? "ic_male" : "ic_female")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
        }
        .frameHorizontalExpand(alignment: .leading)
    }

    @ViewBuilder
    private func addressRow(address: String) -> some View {
        HStack(alignment: .top) {
            Text("Address: ")
                .modifier(infoLabelTextStyle)
                .frame(width: 110, alignment: .leading)

            Text(address)
                .modifier(infoTextStyle)
        }
        .frameHorizontalExpand(alignment: .leading)
    }

    @ViewBuilder
    private var profileSkeleton: some View {
        ScrollView {
            VStack(spacing: 24) {
                CircleSkeletionView()
                    .frame(width: 160, height: 160)
                    .shimmering()

                // Profile Details
                VStack(spacing: 12) {
                    RoundedRectangleSkeletionView(radius: 4)
                        .frameHorizontalExpand()
                        .frame(height: 20)
                    RoundedRectangleSkeletionView(radius: 4)
                        .frameHorizontalExpand()
                        .frame(height: 20)
                    RoundedRectangleSkeletionView(radius: 4)
                        .frameHorizontalExpand()
                        .frame(height: 20)
                        .padding(.trailing, 120)
                }
                .shimmering()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, sidePadding)
        }
        .background(Color(DSColor.primaryWhite))
    }

    @ViewBuilder
    private var reloadButton: some View {
        Text("Reload Profile")
            .modifier(buttonTextStyle)
            .multilineTextAlignment(.center)
            .lineSpacing(2)
            .padding(4)
            .frame(height: 40)
            .frame(maxWidth: 240)
            .background(Color(DSColor.primaryBlue))
            .cornerRadiusWithBorder(Color(DSColor.black), radius: 8, width: 1, corners: .allCorners)
            .asButton {
                interactor.fetchProfile()
            }
            .frameHorizontalExpand(alignment: .center)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
    }

    @ViewBuilder
    private var errorView: some View {
        ErrorView(state: viewState.errorState) {
            interactor.fetchProfile()
        }
        .disabled(viewState.isLoading)
        .expandInScrollView()
        .background(Color(DSColor.primaryWhite))
    }
}

#if DEBUG
private class PreviewMeInteractor: MeBusinessLogic {
    func fetchProfile() {}
}

#Preview {
    let viewState = MeViewState()
    viewState.profile = Me.FetchProfile.ViewModel(
        profileImageURL: nil,
        title: "Mr",
        firstName: "John",
        lastName: "Doe",
        dateOfBirth: "May 15, 1990",
        age: "35",
        gender: "Male",
        nationality: "US",
        mobile: "(555) 987-6543",
        address: "123 Main Street\nSpringfield, Illinois\nUnited States 62704"
    )
    return MeView(
        selectedTab: .constant(.me),
        viewState: viewState,
        interactor: PreviewMeInteractor()
    )
}
#endif
