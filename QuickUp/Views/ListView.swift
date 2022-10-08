//
//  ListView.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import Foundation
import SwiftUI

struct ListView: View {
    
    @Environment(\.openURL) var openURL
    
    @State var list: CUList
    @State var tasks: [CUTask] = []
    @State var selectedTaskID: CUTask.ID?
    
    var body: some View {
        GeometryReader { geometry in
            #if os(macOS)
            HSplitView {
                ListTableView(tasks: $tasks, selectedTaskID: $selectedTaskID)
                .layoutPriority(1)
                ListDetailView(tasks: $tasks, selectedTaskID: $selectedTaskID)
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            }
            #else
            List {
                ForEach(tasks) { task in
                    NavigationLink {
                        ListDetailView(tasks: $tasks, selectedTaskID: $selectedTaskID, task: task)
                    } label: {
                        Text(task.name)
                    }

                }
            }
            .listStyle(.plain)
            #endif
        }
        .task {
            if let tasksList = await getTasks(listID: list.id, orderBy: .ID, includeClosed: true) {
                tasks = tasksList.tasks
            }
        }
        .navigationTitle(list.name)
    }
}

