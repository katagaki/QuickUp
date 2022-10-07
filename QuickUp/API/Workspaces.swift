//
//  Workspaces.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import Foundation

struct CUWorkspaceList: Codable {
    var teams: [CUWorkspace]
}

struct CUWorkspace: Codable {
    var id: String
    var name: String
    var color: String
    var avatar: String
    var members: [CUMember]
}

func getWorkspaces() async -> CUWorkspaceList? {
    let request = request(url: "\(apiEndpoint)/team",
                          method: .GET)
    return await withCheckedContinuation { (continuation: CheckedContinuation<CUWorkspaceList?, Never>) in
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                continuation.resume(returning: nil)
            } else {
                if let data = data {
                    do {
                        let workspaces = try JSONDecoder().decode(CUWorkspaceList.self, from: data)
                        print("Fetched \(workspaces.teams.count) workspace(s).")
                        continuation.resume(returning: workspaces)
                    } catch {
                        print("An error occurred while fetching workspaces! This is the error: ")
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
