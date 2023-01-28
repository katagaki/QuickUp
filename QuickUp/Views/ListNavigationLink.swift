//
//  ListNavigationLink.swift
//  QuickUp
//
//  Created by 堅書 on 28/1/23.
//

import SwiftUI

struct ListNavigationLink: View {
    
    @Binding var loadingLists: [String:Bool]
    @State var list: CUList
    
    var body: some View {
        NavigationLink {
            ListView(loadingLists: $loadingLists, list: list)
        } label: {
            #if os(macOS)
            HStack(spacing: 4.0) {
                Image(systemName: "list.dash")
                Text(list.name)
                Spacer()
                if loadingLists[list.id] == true {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                }
            }
            #else
            HStack(spacing: 8.0) {
                Image(systemName: "list.dash")
                Text(list.name)
                Spacer()
                if loadingLists[list.id] == true {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                }
            }
            #endif
        }
    }
    
}
