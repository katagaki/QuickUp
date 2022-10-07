//
//  Folders.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import Foundation

struct CUFolderList: Codable {
    var folders: [CUFolder]
}

struct CUFolder: Codable {
    var id: String
    var name: String
    var orderindex: Int?
    var override_statuses: Bool?
    var hidden: Bool
    var space: CUSpace?
    var task_count: String?
    var lists: [CUList]?
    var permission_level: String?
    var access: Bool?
    
    // MARK: QuickUp customization
    
    mutating func setLists(_ lists: [CUList]) {
        self.lists = lists
    }
    
}

func getFolders(spaceID: String, archived: Bool = false) async -> CUFolderList? {
    let request = request(url: "\(apiEndpoint)/space/\(spaceID)/folder?archived=\(archived ? "true" : "false"))",
                          method: .GET)
    return await withCheckedContinuation { (continuation: CheckedContinuation<CUFolderList?, Never>) in
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                continuation.resume(returning: nil)
            } else {
                if let data = data {
                    do {
                        let folders = try JSONDecoder().decode(CUFolderList.self, from: data)
                        print("Fetched \(folders.folders.count) folder(s).")
                        continuation.resume(returning: folders)
                    } catch {
                        print("An error occurred while fetching folders! This is the error: ")
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
