//
//  CatCardView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import SwiftUI

struct CatCardView: View, Equatable {
    // MARK: - Property
    @Binding var expandBreedId: String?
    private let breed: Cats.FetchBreeds.ViewModel.BreedItem
    private var isExpand: Bool {
        expandBreedId == breed.id
    }

    // MARK: - Text Style
    private let titleTextStyle = TextStyler(
        font: DSFont.body1.font,
        color: Color(DSColor.black)
    )
    private let detailLabelTextStyle = TextStyler(
        font: DSFont.body3.font,
        color: Color(DSColor.gray5)
    )
    private let detailTextStyle = TextStyler(
        font: DSFont.body3.font,
        color: Color(DSColor.black)
    )

    // MARK: - Equatable
    static func == (lhs: CatCardView, rhs: CatCardView) -> Bool {
        lhs.breed == rhs.breed
        && lhs.expandBreedId == rhs.expandBreedId
    }

    // MARK: - Init
    init(
        expandBreedId: Binding<String?>,
        breed: Cats.FetchBreeds.ViewModel.BreedItem
    ) {
        self._expandBreedId = expandBreedId
        self.breed = breed
    }

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(breed.breed)
                    .modifier(titleTextStyle)
                    .frameHorizontalExpand(alignment: .leading)

                Image(systemName: "chevron.down")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(Color(DSColor.gray5))
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(isExpand ? -180 : 0), anchor: .center)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .contentShape(.rect)
            .asButton {
                expandBreedId = isExpand ? nil : breed.id
            }
            HDividerView()

            if isExpand {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        detailRow(label: "Country", value: breed.country)
                        detailRow(label: "Origin", value: breed.origin)
                        detailRow(label: "Coat", value: breed.coat)
                        detailRow(label: "Pattern", value: breed.pattern)
                    }
                    .frameHorizontalExpand(alignment: .leading)
                    .padding(.leading, 32)
                    .padding(.trailing, 16)
                    .padding(.vertical, 8)
                    HDividerView()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: - View Component
    @ViewBuilder
    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label): ")
                .modifier(detailLabelTextStyle)
                .frame(width: 70, alignment: .leading)
            Text(value)
                .modifier(detailTextStyle)
        }
        .minimumScaleFactor(0.8)
    }
}

struct CatCardSkeletonView: View {
    // MARK: - View Body
    var body: some View {
        HStack {
            RoundedRectangleSkeletionView(radius: 4)
                .frame(width: 120, height: 20)
                .frameHorizontalExpand(alignment: .leading)
                .shimmering()
            Image(systemName: "chevron.down")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(Color(DSColor.gray5))
                .frame(width: 20, height: 20)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        HDividerView()
    }
}

#Preview {
    return ScrollView {
        VStack(alignment: .center, spacing: 0) {
            CatCardView(
                expandBreedId: .constant("Persian"),
                breed: Cats.FetchBreeds.ViewModel.BreedItem(
                    id: "Persian",
                    breed: "Persian",
                    country: "Iran",
                    origin: "Natural",
                    coat: "Long",
                    pattern: "Solid"
                )
            )
            CatCardView(
                expandBreedId: .constant("Siamese"),
                breed: Cats.FetchBreeds.ViewModel.BreedItem(
                    id: "Siamese",
                    breed: "Siamese",
                    country: "Thailand",
                    origin: "Natural",
                    coat: "Short",
                    pattern: "Colorpoint"
                )
            )
            CatCardSkeletonView()
        }
        .padding(16)
    }
}
