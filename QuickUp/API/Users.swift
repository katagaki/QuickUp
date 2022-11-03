//
//  Users.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import Foundation

struct CUMember: Codable {
    var user: CUMemberInfo
}

struct CUMemberInfo: Codable {
    var id: Int?
    var username: String?
    var color: String?
    var initials: String?
    var email: String?
    var profilePicture: String?
}
