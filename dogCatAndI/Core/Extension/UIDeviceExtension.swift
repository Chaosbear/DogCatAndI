//
//  UIDeviceExtension.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import UIKit

extension UIDevice {
    static var isPhone: Bool {
        current.userInterfaceIdiom == .phone
    }
}
