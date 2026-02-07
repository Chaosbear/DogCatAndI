//
//  FontExtension.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 7/2/2569 BE.
//

import SwiftUI

extension Font {
    static func scaledSystem(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> Font {
        return .system(
            size: UIFontMetrics.default.scaledValue(for: size),
            weight: weight,
            design: design
        )
    }
}
