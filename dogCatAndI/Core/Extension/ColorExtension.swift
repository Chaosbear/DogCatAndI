//
//  ColorExtension.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import SwiftUI
import UIKit

extension Color {
    init(_ hexInt: IntegerLiteralType) {
        if (0x0...0xFFFFFF).contains(hexInt) {
            let (r, g, b) = ((hexInt >> 16 & 0xFF), (hexInt >> 8 & 0xFF), (hexInt & 0xFF))
            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                opacity: 1
            )
        } else {
            self.init(uiColor: .white)
        }
    }

    init(
        light lightHex: IntegerLiteralType,
        night nightHex: IntegerLiteralType,
        lightAlpha: Double = 1,
        nightAlpha: Double = 1
    ) {
        self.init(uiColor: UIColor(
            light: lightHex,
            night: nightHex,
            lightAlpha: lightAlpha,
            nightAlpha: nightAlpha
        ))
    }
}

extension UIColor {
    convenience init(_ hexInt: IntegerLiteralType, alpha: Double = 1) {
        if (0x0...0xFFFFFF).contains(hexInt) {
            let (r, g, b) = ((hexInt >> 16 & 0xFF), (hexInt >> 8 & 0xFF), (hexInt & 0xFF))
            self.init(
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                alpha: alpha
            )
        } else {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

    convenience init(
        light lightHex: IntegerLiteralType,
        night nightHex: IntegerLiteralType,
        lightAlpha: Double = 1,
        nightAlpha: Double = 1
    ) {
        self.init(dynamicProvider: { traitCollection in
            return traitCollection.userInterfaceStyle == .light ? UIColor.init(lightHex, alpha: lightAlpha) : UIColor.init(nightHex, alpha: nightAlpha)
        })
    }
}
