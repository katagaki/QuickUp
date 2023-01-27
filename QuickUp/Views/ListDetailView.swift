//
//  ListDetailView.swift
//  QuickUp
//
//  Created by 堅書 on 8/10/22.
//

import SwiftUI

struct ListDetailView: View {
    
    @Binding var tasks: [CUTask]
    @Binding var selectedTaskID: CUTask.ID?
    
    @State var task: CUTask?
    @State var comments: [CUTaskComment] = []
    
    @State var section: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            if let task = task {
                TaskHeaderView(task: self.$task)
                Divider()
                switch section {
                case 1:
                    TaskCommentsView(comments: $comments)
                default:
                    if #available(macOS 13.0, *) {
                        TextEditor(text: .constant(task.description ?? ""))
                            .font(.body)
                            .scrollContentBackground(.hidden)
                    } else {
                        TextEditor(text: .constant(task.description ?? ""))
                            .font(.body)
                    }
                }
                Picker(selection: $section) {
                    Text("Description").tag(0)
                    Text("Comments").tag(1)
                } label: { }
                .pickerStyle(.segmented)
                Text("Created: " + toReadable(task.date_created) + " by " + (task.creator.username ?? "ClickUp User"))
                Text("Updated: " + toReadable(task.date_updated))
                Divider()
                TaskToolbarView(task: self.$task)
            } else {
                Text("Select a task to view its details.")
                Spacer()
            }
        }
        .onChange(of: selectedTaskID) { _ in
            if let selectedTaskID = (selectedTaskID),
               let selectedTask = tasks.first(where: {$0.id == selectedTaskID.description}) {
                task = selectedTask
                Task {
                    comments = await getComments(taskID: selectedTask.id)?.comments ?? []
                }
            }
        }
        #if os(iOS)
        .task {
            if let task = task {
                comments = await getComments(taskID: task.id)?.comments ?? []
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
