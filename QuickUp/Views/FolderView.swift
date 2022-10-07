//
//  FolderView.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import SwiftUI

struct FolderView: View {
    
    @State var folder: CUFolder
    @State var folderLists: [CUList] = []
    
    var body: some View {
        List {
            ForEach(folderLists, id: \.id) { list in
                NavigationLink {
                    ListView()
                } label: {
                    Text(list.name)
                }
            }
        }
        .task {
            await loadLists()
        }
        .navigationTitle(folder.name)
    }
    
    func loadLists() async {
        if let listsList = await getLists(folderID: folder.id) {
            folderLists = listsList.lists
        }
    }
}
