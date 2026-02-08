//
//  SwiftUITextExtension.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 9/2/2569 BE.
//

import SwiftUI

extension Text {
    func textStyle(_ style: TextStyler) -> Text {
        self
            .font(style.font)
            .foregroundColor(style.color)
    }
}
