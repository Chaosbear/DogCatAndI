//
//  AppConfig.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 7/2/2569 BE.
//

import Foundation

enum AppEnvironment: String {
    case prod
    case uat
    case dev
}

enum Config {
    // MARK: - Info From Config File
    static let appConfig: [String: Any] = Bundle.main.infoDictionary?["AppConfig"] as! [String: Any]

    // app environment
    static let env: AppEnvironment = AppEnvironment.init(rawValue: getConfigValue(key: "APP_ENV")) ?? .prod

    // baseURL
    static let dogURL: URL = URL(string: getConfigValue(key: "DOG_URL"))!
    static let catURL: URL = URL(string: getConfigValue(key: "CAT_URL"))!
    static let meURL: URL = URL(string: getConfigValue(key: "ME_URL"))!

    // MARK: - Get Plist Value
    static func getConfigValue(key: String) -> String {
        return appConfig[key] as! String
    }
}
