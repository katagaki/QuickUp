//
//  TaskHeaderView.swift
//  QuickUp
//
//  Created by 堅書 on 2023/01/27.
//

import SwiftUI

struct TaskHeaderView: View {
    
    @Binding var task: CUTask?
    
    var body: some View {
        if let task = task {
            HStack(alignment: .center, spacing: 4.0) {
                Text(task.name)
                    .font(.title2)
            }
            Divider()
            HStack(alignment: .center, spacing: 4.0) {
                Text(task.status.status.uppercased())
                    .font(.system(.subheadline))
                    .padding(4.0)
                    .background {
                        RoundedRectangle(cornerRadius: 4.0)
                            .foregroundColor(Color(hex: task.status.color))
                            .opacity(0.25)
                    }
                Spacer()
                Text(task.custom_id != nil ? task.custom_id! : task.id)
                    .font(.system(.subheadline, design: .monospaced))
                    .padding(4.0)
                    .background {
                        RoundedRectangle(cornerRadius: 4.0)
                            .strokeBorder()
                            .foregroundColor(.primary)
                            .opacity(0.5)
                    }
            }
        }
    }
}
