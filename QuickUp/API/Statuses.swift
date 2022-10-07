//
//  Statuses.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import Foundation

struct CUStatus: Codable {
    var id: String?
    var status: String
    var color: String
    var orderindex: Int?
    var type: String?
    var hide_label: Bool?
}
