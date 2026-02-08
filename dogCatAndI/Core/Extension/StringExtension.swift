//
//  StringExtension.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 9/2/2569 BE.
//

import Foundation

extension String {
    func withPlaceholder(_ placeholder: String = "-") -> String {
        self.isEmpty ? placeholder : self
    }
}
