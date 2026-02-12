//
//  Utils.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 7/2/2569 BE.
//

import Foundation

struct Utils {
    // MARK: - Data Converter
    static func dataToCodable<T: Codable>(
        data: Data,
        type: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        let result = try decoder.decode(type, from: data)
        return result
    }

    // MARK: - Date Time Formatter
    enum DateFormatOutput {
        case dateTime, dateTimeAmPm, date, time
        case custom(String)

        var value: String {
            switch self {
            case .dateTime: return "d MMM yyyy HH:mm"
            case .dateTimeAmPm: return "d MMM yyyy h:mma"
            case .date: return "d MMM yyyy"
            case .time: return "HH:mm:ss"
            case .custom(let format): return format
            }
        }
    }

    enum DateFormatLocale {
        case input
        case output

        var identifier: String {
            switch self {
            case .input: return "en_US_POSIX"
            case .output: return currentLocale
            }
        }
    }

    static func date(from dateStr: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        var dateValue = formatter.date(from: dateStr)
        if dateValue == nil {
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            dateValue = formatter.date(from: dateStr)
        }
        return dateValue
    }

    static func dateFormat(from dateStr: String, format: DateFormatOutput = .date) -> String? {
        let inputFormatter = ISO8601DateFormatter()

        var dateValue = inputFormatter.date(from: dateStr)
        if dateValue == nil {
            inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            dateValue = inputFormatter.date(from: dateStr)
        }
        guard let date = dateValue else { return nil }

        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format.value
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        return formatter.string(from: date)
    }

    // MARK: - Localization
    static var currentLocale: String {
        Locale.current.identifier
    }
}

