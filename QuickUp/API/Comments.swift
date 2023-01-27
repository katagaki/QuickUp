//
//  Comments.swift
//  QuickUp
//
//  Created by 堅書 on 2023/01/25.
//

import Foundation

struct CUTaskCommentList: Codable {
    var comments: [CUTaskComment]
}

struct CUTaskComment: Codable {
    var id: String
    var comment: [CUTaskCommentContent]? // TODO: Process as global text block
    var comment_text: String
    var user: CUMemberInfo
    var resolved: Bool?
    var assignee: CUMemberInfo?
    var assigned_by: CUMemberInfo?
    var reactions: [CUTaskCommentReaction]
    var date: String
}

struct CUTaskCommentContent: Codable {
    var text: String
    // TODO: Parse attributes
    var type: String?
    var user: CUMemberInfo?
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case type = "type"
        case user = "user"
    }
}

struct CUTaskCommentReaction: Codable {
    var reaction: String
    var date: String
    var user: CUMemberInfo
}

func getComments(taskID: String) async -> CUTaskCommentList? {
    let request = request(url: "\(apiEndpoint)/task/\(taskID)/comment",
                          method: .GET)
    return await withCheckedContinuation { (continuation: CheckedContinuation<CUTaskCommentList?, Never>) in
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                continuation.resume(returning: nil)
            } else {
                if let data = data {
                    do {
                        let comments = try JSONDecoder().decode(CUTaskCommentList.self, from: data)
                        print("Fetched \(comments.comments.count) comment(s).")
                        continuation.resume(returning: comments)
                    } catch {
                        print("An error occurred while fetching comments! This is the error: ")
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
