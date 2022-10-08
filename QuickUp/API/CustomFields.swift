//
//  CustomFields.swift
//  QuickUp
//
//  Created by 堅書 on 8/10/22.
//

import Foundation

struct CUCustomField: Codable {
    var id: String
    var name: String
    var type: String
    var type_config: CUCustomFieldConfig?
    var date_created: String?
    var hide_from_guests: Bool
    var required: Bool?
}

struct CUCustomFieldConfig: Codable {
    var new_drop_down: Bool?
    var options: [CUCustomFieldConfigOption]?
    var end: Int?
    var start: Int?
}

struct CUCustomFieldConfigOption: Codable {
    var id: String
    var name: String?
    var label: String?
    var color: String?
    var orderindex: Int?
}
