//
//  TaskCommentsView.swift
//  QuickUp
//
//  Created by 堅書 on 2023/01/27.
//

import SwiftUI

struct TaskCommentsView: View {
    
    @Binding var comments: [CUTaskComment]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack (spacing: 2.0) {
                ForEach(comments, id: \.id) { comment in
                    TaskCommentView(comment: comment)
                }
            }
            .padding(5.0)
        }
    }
}
