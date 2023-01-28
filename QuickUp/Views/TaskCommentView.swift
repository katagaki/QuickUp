//
//  TaskCommentView.swift
//  QuickUp
//
//  Created by 堅書 on 2023/01/27.
//

import SwiftUI

struct TaskCommentView: View {
    
    @State var comment: CUTaskComment
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(comment.user.username ?? "ClickUp User")
                .font(.body)
                .bold()
            Text(comment.comment_text.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.body)
        }
        .padding(.bottom, 8.0)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}
