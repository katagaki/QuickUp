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
    @State var currentPage: Int = 0
    @State var isLoading: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            #if os(macOS)
            HSplitView {
                ListTableView(loadNextPage: self.loadNextPage, tasks: $tasks, selectedTaskID: $selectedTaskID)
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
                    .onAppear {
                        Task {
                            await self.loadNextPage(checking: task)
                        }
                    }
                }
            }
            .listStyle(.plain)
            #endif
        }
        .task {
            await loadNextPage(checking: nil)
        }
        .navigationTitle(list.name)
    }
    
    func loadNextPage(checking currentTask: CUTask?) async {
        if let currentTask = currentTask {
            if !isLoading {
                let thresholdIndex = tasks.index(tasks.endIndex, offsetBy: -10)
                if tasks.firstIndex(where: { $0.id == currentTask.id }) == thresholdIndex {
                    print(currentTask.id)
                    isLoading = true
                    currentPage += 1
                    if let tasksList = await getTasks(listID: list.id, page: currentPage, orderBy: .ID, includeClosed: true) {
                        tasks.append(contentsOf: tasksList.tasks)
                        isLoading = false
                    }
                }
            }
        } else {
            tasks = await getTasks(listID: list.id, page: currentPage, orderBy: .ID, includeClosed: true)?.tasksArranged() ?? []
        }
    }
    
}

