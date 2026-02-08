//
//  ColorExtension.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import SwiftUI
import UIKit

struct ColorConverter {
    static func hexToRgba(_ hex: String) -> (red: Double, green: Double, blue: Double, alpha: Double) {
        var hexString: String = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).uppercased()
        if hexString.hasPrefix("#") {
            _ = hexString.removeFirst()
        }

        // Fix invalid values
        if hexString.count > 8 {
            hexString = String(hexString.prefix(8))
        }

        // Scanner creation
        var color: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&color)

        let r, g, b, a: UInt64
        switch hexString.count {
        case 1: // R (4-bit) gray color
            let gray = (color & 0xF) * 17
            (r, g, b, a) = (gray, gray, gray, 255)
        case 2: // RR (8-bit) gray color
            (r, g, b, a) = (color, color, color, 255)
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((color >> 8 & 0xF) * 17, (color >> 4 & 0xF) * 17, (color & 0xF) * 17, 255)
        case 4: // RGBA (16-bit)
            (r, g, b, a) = ((color >> 12 & 0xF) * 17, (color >> 8 & 0xF) * 17, (color >> 4 & 0xF) * 17, (color & 0xF) * 17)
        case 6: // RRGGBB (24-bit)
            (r, g, b, a) = ((color >> 16 & 0xFF), (color >> 8 & 0xFF), (color & 0xFF), 255)
        case 7: // RRGGBBA (28-bit)
            (r, g, b, a) = ((color >> 20 & 0xFF), (color >> 12 & 0xFF), (color >> 4 & 0xFF), (color & 0xF) * 17)
        case 8: // RRGGBBAA (32-bit)
            (r, g, b, a) = ((color >> 24 & 0xFF), (color >> 16 & 0xFF), (color >> 8 & 0xFF), (color & 0xFF))
        default:
            (r, g, b, a) = (255, 255, 255, 255)
        }
        return (
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}

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

    init(_ hex: String) {
        let rgba = ColorConverter.hexToRgba(hex)
        self.init(
            .sRGB,
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            opacity: rgba.alpha
        )
    }

    init(light lightHex: String, night nightHex: String) {
        self.init(uiColor: UIColor(light: lightHex, night: nightHex))
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

    convenience init(_ hex: String) {
        let rgba = ColorConverter.hexToRgba(hex)
        self.init(
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            alpha: rgba.alpha
        )
    }

    convenience init(light lightHex: String, night nightHex: String) {
        self.init(dynamicProvider: { traitCollection in
            return traitCollection.userInterfaceStyle == .light ? UIColor.init(lightHex) : UIColor.init(nightHex)
        })
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
