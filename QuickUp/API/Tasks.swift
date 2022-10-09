//
//  Tasks.swift
//  QuickUp
//
//  Created by 堅書 on 8/10/22.
//

import Foundation

struct CUTasksList: Codable {
    var tasks: [CUTask]
}

struct CUTask: Codable, Identifiable {
    var id: String
    var custom_id: String?
    var name: String
    var text_content: String?
    var description: String?
    var status: CUStatus
    var orderindex: String
    var date_created: String
    var date_updated: String
    var date_closed: String?
    var archived: Bool
    var creator: CUMemberInfo
    var assignees: [CUMemberInfo]
    var watchers: [CUMemberInfo]
    var checklists: [CUTaskChecklist]?
    var tags: [CUTaskTag]
    var parent: String?
    var priority: CUPriority?
    var due_date: String?
    var start_date: String?
    var points: Int?
    var time_estimate: Int?
    var custom_fields: [CUCustomField]
    var dependencies: [CUTaskDependency]
    var linked_tasks: [CUTaskLink]
    var team_id: String
    var url: String
    var permission_level: String
    var list: CUList
    var project: CUFolder
    var folder: CUFolder
    var space: CUSpace
}

struct CUTaskChecklist: Codable {
    var id: String
    var task_id: String
    var name: String
    var date_created: String
    var orderindex: Int
    var creator: Int
    var resolved: Int
    var unresolved: Int
    var items: [CUTaskChecklistItem]
}

struct CUTaskChecklistItem: Codable {
    var id: String
    var name: String
    var orderindex: Int
    var assignee: CUMemberInfo?
    var group_assignee: String?
    var resolved: Bool
    var parent: String?
    var date_created: String
    var children: [String]
}

struct CUTaskTag: Codable {
    var name: String
    var tag_fg: String
    var tag_bg: String
    var creator: Int
}

struct CUTaskDependency: Codable {
    var task_id: String
    var depends_on: String
    var type: Int
    var date_created: String
    var userid: String
    var workspace_id: String
}

struct CUTaskLink: Codable {
    var task_id: String
    var link_id: String
    var date_created: String
    var userid: String
    var workspace_id: String?
}

enum CUTaskOrder: String {
    case ID = "id"
    case CreatedDate = "created"
    case UpdatedDate = "updated"
    case DueDate = "due_date"
}

func getTasks(listID: String,
              archived: Bool = false,
              orderBy order: CUTaskOrder = .CreatedDate,
              inReverseOrder reversed: Bool = false,
              includeSubtasks: Bool = false,
              filterBy statuses: [String] = [],
              includeClosed: Bool = false) async -> CUTasksList? {
    let statusQuery = statuses.reduce("statuses=") { s1, s2 in
        s1 + "&statuses=" + s2
    }
    let request = request(url: "\(apiEndpoint)/list/\(listID)/task?archived=\(archived ? "true" : "false")&\(order.rawValue)&reverse=\(reversed ? "true" : "false")&subtasks=\(includeSubtasks ? "true" : "false&\(statusQuery)&include_closed=\(includeClosed ? "true" : "false")")",
                          method: .GET)
    // TODO: assignees; tags; due_date_gt; due_date_lt; date_created_gt; date_created_lt; date_updated_gt; date_updated_lt; custom_fields
    return await withCheckedContinuation { (continuation: CheckedContinuation<CUTasksList?, Never>) in
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                continuation.resume(returning: nil)
            } else {
                if let data = data {
                    do {
                        let tasks = try JSONDecoder().decode(CUTasksList.self, from: data)
                        print("Fetched \(tasks.tasks.count) task(s).")
                        continuation.resume(returning: tasks)
                    } catch {
                        print("An error occurred while fetching tasks! This is the error: ")
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
