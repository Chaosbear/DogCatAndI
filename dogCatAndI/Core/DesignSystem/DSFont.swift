//
//  DSFont.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 7/2/2569 BE.
//

import SwiftUI

enum DSFont {
    /// 30
    case h1
    /// 26
    case h2
    /// 22
    case h3
    /// 18
    case subTitle
    /// 18
    case subTitleBold
    /// 16
    case body1
    /// 16
    case body1Bold
    /// 14
    case body2
    /// 14
    case body2Bold
    /// 12
    case body3
    /// 12
    case body3Bold
    /// 8
    case note
    /// 8
    case noteFix

    var font: TextStyler.FontType {
        switch self {
        case .h1: return .system(size: 30, weight: .bold)
        case .h2: return .system(size: 26, weight: .bold)
        case .h3: return .system(size: 22, weight: .bold)
        case .subTitle: return .system(size: 18, weight: .semibold)
        case .subTitleBold: return .system(size: 18, weight: .bold)
        case .body1: return .system(size: 16, weight: .regular)
        case .body1Bold: return .system(size: 16, weight: .bold)
        case .body2: return .system(size: 14, weight: .regular)
        case .body2Bold: return .system(size: 14, weight: .bold)
        case .body3: return .system(size: 12, weight: .regular)
        case .body3Bold: return .system(size: 12, weight: .bold)
        case .note: return .system(size: 8, weight: .regular)
        case .noteFix: return .fixSystem(size: 8, weight: .regular)
        }
    }
}

