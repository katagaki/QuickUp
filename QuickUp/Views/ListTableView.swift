//
//  ListTableView.swift
//  QuickUp
//
//  Created by 堅書 on 8/10/22.
//

import SwiftUI

struct ListTableView: View {
    
    @Binding var tasks: [CUTask]
    @Binding var selectedTaskID: CUTask.ID?
    
    var body: some View {
        Table(tasks, selection: $selectedTaskID) {
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
    }
}
