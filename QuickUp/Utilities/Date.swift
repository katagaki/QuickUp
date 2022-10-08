//
//  Date.swift
//  QuickUp
//
//  Created by 堅書 on 8/10/22.
//

import Foundation

func toReadable(_ unixDateTime: String) -> String {
    if let timeInMilliseconds = Double(unixDateTime) {
        let date = Date(timeIntervalSince1970: timeInMilliseconds / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    } else {
        return ""
    }
}
