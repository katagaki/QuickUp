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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            if let task = task {
                HStack(alignment: .center, spacing: 4.0) {
                    Text(task.name)
                        .font(.title2)
                }
                Divider()
                HStack(alignment: .center, spacing: 4.0) {
                    Text(task.status.status.uppercased())
                        .foregroundColor(Color(hex: task.status.color))
                        .font(.system(.subheadline))
                    Spacer()
                    Text(task.custom_id != nil ? task.custom_id! : task.id)
                        .font(.system(.subheadline, design: .monospaced))
                        .padding(4.0)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4.0)
                                .strokeBorder()
                                .foregroundColor(.primary)
                                .opacity(0.5)
                        }
                }
                Divider()
                TextEditor(text: .constant(task.description ?? ""))
                    .scrollContentBackground(.hidden)
                Spacer()
                Divider()
                Text("Created: " + toReadable(task.date_created) + " by " + (task.creator.username ?? "ClickUp User"))
                Text("Updated: " + toReadable(task.date_updated))
            } else {
                Text("Select a task to view its details.")
                Spacer()
            }
        }
        .onChange(of: selectedTaskID) { _ in
            if let selectedTaskID = (selectedTaskID),
               let selectedTask = tasks.first(where: {$0.id == selectedTaskID.description}) {
                task = selectedTask
            }
        }
        #if os(iOS)
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
