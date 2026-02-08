//
//  MeView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 6/2/2569 BE.
//

import SwiftUI
import Combine

// MARK: - Me Store
@MainActor
class MeViewState: ObservableObject {
    @Published var profile: Me.FetchProfile.ViewModel?
    @Published var isLoading = false
    @Published var errorState: ErrorViewStateModel = .noError
}

// MARK: - Me View

struct MeView: View {
    @ObservedObject var store: MeViewState
    let interactor: MeBusinessLogic

    var body: some View {
        VStack(spacing: 0) {
            if let profile = store.profile {
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Image
                        AsyncImage(url: profile.profileImageURL) { phase in
                            switch phase {
                            case .empty:
                                Image("image_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            case .failure:
                                Image("image_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                        .padding(.top, 20)

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
                        .padding(.horizontal, 16)
                    }
                }
            } else if let error = store.errorMessage {
                VStack(spacing: 16) {
                    Text("Failed to load profile")
                        .font(.headline)
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Spacer(minLength: 0)

            // Reload button
            Button(action: {
                interactor.fetchProfile(request: Me.FetchProfile.Request())
            }) {
                Text("Reload Profile")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
        .loadingOverlay(isLoading: store.isLoading)
        .onAppear {
            if store.profile == nil {
                interactor.fetchProfile(request: Me.FetchProfile.Request())
            }
        }
    }

    // MARK: - Profile Rows

    @ViewBuilder
    private func profileRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .frame(width: 110, alignment: .leading)

            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func genderRow(gender: String) -> some View {
        HStack(alignment: .center) {
            Text("Gender:")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .frame(width: 110, alignment: .leading)

            Image(gender.lowercased() == "male" ? "ic_male" : "ic_female")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)

            Spacer()
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func addressRow(address: String) -> some View {
        HStack(alignment: .top) {
            Text("Address:")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .frame(width: 110, alignment: .leading)

            Text(address)
                .font(.system(size: 14))
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#if DEBUG
private class PreviewMeInteractor: MeBusinessLogic {
    func fetchProfile(request: Me.FetchProfile.Request) {}
}

#Preview {
    let store = MeStore()
    store.profile = Me.FetchProfile.ViewModel(
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
    return MeView(store: store, interactor: PreviewMeInteractor())
}
#endif
