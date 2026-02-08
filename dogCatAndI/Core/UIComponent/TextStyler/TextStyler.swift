//
//  TextStyler.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 7/2/2569 BE.
//

import SwiftUI

struct TextStyler: ViewModifier {
    enum FontType {
        case custom(
            name: String,
            size: CGFloat
        )
        case fixCustom(
            name: String,
            fixSize: CGFloat
        )
        case system(
            size: CGFloat,
            weight: Font.Weight = .regular,
            design: Font.Design = .default
        )
        case fixSystem(
            size: CGFloat,
            weight: Font.Weight = .regular,
            design: Font.Design = .default
        )

        var value: Font {
            switch self {
            case .custom(let name, let size):
                return .custom(name, size: size)
            case .fixCustom(let name, let fixSize):
                return .custom(name, fixedSize: fixSize)
            case .system(let size, let weight, let design):
                return .scaledSystem(
                    size: size,
                    weight: weight,
                    design: design
                )
            case .fixSystem(let size, let weight, let design):
                return .system(
                    size: size,
                    weight: weight,
                    design: design
                )
            }
        }
    }

    // observe text size change by
    // declaring dynamicTypeSize environment
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    private var initialFont: FontType
    var font: Font { initialFont.value }
    private(set) var color: Color

    init(
        font: FontType,
        color: Color
    ) {
        self.initialFont = font
        self.color = color
    }

    func body(content: Content) -> some View {
        content
            .font(initialFont.value)
            .foregroundColor(color)
    }
}
