//
//  Lists.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import Foundation

struct CUListsList: Codable {
    var lists: [CUList]
}

struct CUList: Codable {
    var id: String
    var name: String
    var access: Bool?
    var orderindex: Int?
    var content: String?
    var status: CUStatus?
    var priority: CUPriority?
    var assignee: String?
    var task_count: Int?
    var due_date: String?
    var start_date: String?
    var folder: CUFolder?
    var space: CUSpace?
    var archived: Bool?
    var override_statuses: Bool?
    var statuses: [CUStatus]?
    var permission_level: String?
}

func getFolderLessLists(spaceID: String, archived: Bool = false) async -> CUListsList? {
    let request = request(url: "\(apiEndpoint)/space/\(spaceID)/list?archived=\(archived ? "true" : "false"))",
                          method: .GET)
    return await withCheckedContinuation { (continuation: CheckedContinuation<CUListsList?, Never>) in
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                continuation.resume(returning: nil)
            } else {
                if let data = data {
                    do {
                        let lists = try JSONDecoder().decode(CUListsList.self, from: data)
                        print("Fetched \(lists.lists.count) list(s).")
                        continuation.resume(returning: lists)
                    } catch {
                        print("An error occurred while fetching lists! This is the error: ")
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

func getLists(folderID: String, archived: Bool = false) async -> CUListsList? {
    let request = request(url: "\(apiEndpoint)/folder/\(folderID)/list?archived=\(archived ? "true" : "false"))",
                          method: .GET)
    return await withCheckedContinuation { (continuation: CheckedContinuation<CUListsList?, Never>) in
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                continuation.resume(returning: nil)
            } else {
                if let data = data {
                    do {
                        let lists = try JSONDecoder().decode(CUListsList.self, from: data)
                        print("Fetched \(lists.lists.count) list(s).")
                        continuation.resume(returning: lists)
                    } catch {
                        print("An error occurred while fetching lists! This is the error: ")
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
