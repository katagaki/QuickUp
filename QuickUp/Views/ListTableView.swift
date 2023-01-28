//
//  ListTableView.swift
//  QuickUp
//
//  Created by 堅書 on 8/10/22.
//

import SwiftUI

struct ListTableView: View {
    
    var loadNextPage: (_ : CUTask?) async -> Void
    
    @Binding var tasks: [CUTask]
    @Binding var selectedTaskID: CUTask.ID?
    @State var sortOrder: [KeyPathComparator<CUTask>] = [
        .init(\.name, order: SortOrder.forward),
        .init(\.status.status, order: SortOrder.forward)
    ]
    
    var body: some View {
        Table(tasks, selection: $selectedTaskID, sortOrder: $sortOrder) {
            TableColumn("Title", value: \.name)
                .width(min: 300.0)
            TableColumn("Status", value: \.status.status) { task in
                Text(task.status.status.localizedUppercase)
                    .font(.caption)
                    .padding(4.0)
                    .background {
                        RoundedRectangle(cornerRadius: 4.0)
                            .foregroundColor(Color(hex: task.status.color))
                            .opacity(0.25)
                    }
                    .onAppear {
                        Task {
                            await self.loadNextPage(task)
                        }
                    }
            }
            .width(min: 100.0, ideal: 125.0, max: 200.0)
        }
        .onChange(of: sortOrder) { sortOrder in
            tasks.sort(using: sortOrder)
        }
    }
}
