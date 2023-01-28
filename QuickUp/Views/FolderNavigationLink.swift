//
//  FolderNavigationLink.swift
//  QuickUp
//
//  Created by 堅書 on 28/1/23.
//

import SwiftUI

struct FolderNavigationLink: View {
    
    @State var folder: CUFolder
    
    var body: some View {
        NavigationLink {
            #if os(macOS)
            NavigationView {
                FolderView(folder: folder)
            }
            #else
            FolderView(folder: folder)
            #endif
        } label: {
            #if os(macOS)
            HStack(spacing: 4.0) {
                Image(systemName: "folder.fill")
                Text(folder.name)
                Spacer()
            }
            #else
            HStack(spacing: 8.0) {
                Image(systemName: "folder.fill")
                Text(folder.name)
                Spacer()
            }
            #endif
        }
    }
    
}
