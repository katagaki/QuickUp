//
//  Spaces.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import Foundation

struct CUSpaceList: Codable {
    var spaces: [CUSpace]
}

struct CUSpace: Codable {
    var id: String
    var name: String?
    var `private`: Bool?
    var statuses: [CUStatus]?
    var multiple_assignees: Bool?
    var features: CUSpaceFeatureConfiguration?
    var access: Bool?
    
    // MARK: QuickUp customization
    
    @CodableIgnored var folders: [CUFolder]? = []
    @CodableIgnored var lists: [CUList]? = []
    
    mutating func setFolders(_ folders: [CUFolder]) {
        self.folders = folders
    }
    
    mutating func setLists(_ lists: [CUList]) {
        self.lists = lists
    }
    
}

struct CUSpaceFeatureConfiguration: Codable {
    var due_dates: CUDueDatesConfiguration?
    var time_tracking: CUTimeTrackingConfiguration?
    var tags: CUTagsConfiguration?
    var time_estimates: CUTimeEstimatesConfiguration?
    var checklists: CUChecklistsConfiguration?
    var custom_fields: CUCustomFieldsConfiguration?
    var remap_dependencies: CURemapDependenciesConfiguration?
    var dependency_warning: CUDependencyWarningConfiguration?
    var portfolios: CUPortfoliosConfiguration?
}

struct CUDueDatesConfiguration: Codable {
    var enabled: Bool
    var start_date: Bool
    var remap_due_dates: Bool
    var remap_closed_due_date: Bool
}

struct CUTimeTrackingConfiguration: Codable {
    var enabled: Bool
}

struct CUTagsConfiguration: Codable {
    var enabled: Bool
}

struct CUTimeEstimatesConfiguration: Codable {
    var enabled: Bool
}

struct CUChecklistsConfiguration: Codable {
    var enabled: Bool
}

struct CUCustomFieldsConfiguration: Codable {
    var enabled: Bool
}

struct CURemapDependenciesConfiguration: Codable {
    var enabled: Bool
}

struct CUDependencyWarningConfiguration: Codable {
    var enabled: Bool
}

struct CUPortfoliosConfiguration: Codable {
    var enabled: Bool
}

func getSpaces(teamID: String, archived: Bool = false) async -> CUSpaceList? {
    let request = request(url: "\(apiEndpoint)/team/\(teamID)/space?archived=\(archived ? "true" : "false"))",
                          method: .GET)
    return await withCheckedContinuation { (continuation: CheckedContinuation<CUSpaceList?, Never>) in
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                continuation.resume(returning: nil)
            } else {
                if let data = data {
                    do {
                        let spaces = try JSONDecoder().decode(CUSpaceList.self, from: data)
                        print("Fetched \(spaces.spaces.count) space(s).")
                        continuation.resume(returning: spaces)
                    } catch {
                        print("An error occurred while fetching spaces! This is the error: ")
                        print(String(data: data, encoding: .utf8)!)
                        print(error)
                        continuation.resume(returning: nil)
                    }
                } else {
                    print("No data returned.")
                    continuation.resume(returning: nil)
                }
            }
        }.resume()
    }
}
