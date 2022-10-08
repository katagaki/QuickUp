//
//  ListView.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import Foundation
import SwiftUI

struct ListView: View {
        
    @State var list: CUList
    @State var tasks: [CUTask] = []
    @State var selectedTask: CUTask.ID?
    
    var body: some View {
        Table(tasks, selection: $selectedTask) {
            TableColumn("Title", value: \.name)
            TableColumn("Status", value: \.status.status.localizedUppercase)
                .width(min: 100.0, ideal: 150.0, max: 200.0)
            TableColumn("URL") { task in
                Link(destination: URL(string: task.url)!) {
                    Text("Open in ClickUp")
                }
            }
            .width(100.0)
        }
        .task {
            if let tasksList = await getTasks(listID: list.id, orderBy: .ID, includeClosed: true) {
                tasks = tasksList.tasks
            }
        }
        .navigationTitle(list.name)
    }
}

