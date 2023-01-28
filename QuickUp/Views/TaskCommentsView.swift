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
                    Divider()
                        .padding(.bottom, 8.0)
                }
            }
            .padding([.leading, .trailing], 5.0)
            #if os(iOS)
            .padding([.top], 5.0)
            #endif
        }
    }
}
