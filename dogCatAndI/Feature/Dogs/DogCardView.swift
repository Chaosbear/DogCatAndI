//
//  DogCardView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 7/2/2569 BE.
//

import SwiftUI

struct DogCardView: View, Equatable {
    // MARK: - Property
    private let dog: Dogs.FetchDogs.ViewModel.DogItem

    // MARK: - Text Style
    private let titleTextStyle = TextStyler(
        font: DSFont.body3.font,
        color: Color(DSColor.black)
    )

    // MARK: - Equatable
    static func == (lhs: DogCardView, rhs: DogCardView) -> Bool {
        lhs.dog == rhs.dog
    }

    // MARK: - Init
    init(dog: Dogs.FetchDogs.ViewModel.DogItem) {
        self.dog = dog
    }

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: dog.imageURL) { phase in
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
            .frame(height: 120)

            Text(dog.label)
                .modifier(titleTextStyle)
                .lineSpacing(6)
                .multilineTextAlignment(.center)
        }
        .frameHorizontalExpand()
        .padding(12)
        .background(Color(DSColor.gray10))
        .cornerRadius(12)
        .shadow(color: Color(DSColor.gray8), radius: 2, x: 1, y: 1)
    }
}

struct DogCardSkeletonView: View {
    // MARK: - View Body
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangleSkeletionView(radius: 2)
                .scaledToFit()
                .frame(height: 120)

            RoundedRectangleSkeletionView(radius: 4)
                .frame(width: 80, height: 14)
        }
        .shimmering()
        .frameHorizontalExpand()
        .padding(12)
        .background(Color(DSColor.gray10))
        .cornerRadius(12)
        .shadow(color: Color(DSColor.gray8), radius: 2, x: 1, y: 1)
    }
}

#Preview {
    let gridColumns = [GridItem(
        .adaptive(minimum: 120, maximum: 240),
        spacing: 16,
        alignment: .top
    )]
    return ScrollView {
        LazyVGrid(
            columns: gridColumns,
            alignment: .center,
            spacing: 16
        ) {
            DogCardView(dog: .init(
                id: 0,
                imageURL: URL(string: "https://images.dog.ceo/breeds/labrador/n02099712_001.jpg"),
                label: "Dog #1 - Labrador (12:00:00)"
            ))
            DogCardView(dog: .init(
                id: 1,
                imageURL: URL(string: "https://images.dog.ceo/breeds/poodle-standard/n02113799_001.jpg"),
                label: "Dog #2 - Poodle (12:00:01)"
            ))
            DogCardSkeletonView()
        }
        .padding(16)
    }
}
