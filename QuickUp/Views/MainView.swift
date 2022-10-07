//
//  MainView.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import SwiftUI

struct MainView: View {
    
    @State var workspaces: [CUWorkspace] = []
    @State var spaces: [CUSpace] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(spaces, id: \.id) { space in
                    Section {
                        ForEach(space.folders ?? [], id: \.id) { folder in
                            NavigationLink {
                                #if os(macOS)
                                NavigationView {
                                    FolderView(folder: folder)
                                }
                                #else
                                FolderView(folder: folder)
                                #endif
                            } label: {
                                HStack(spacing: 8.0) {
                                    Image(systemName: "folder.fill")
                                    Text(folder.name)
                                }
                            }
                        }
                        ForEach(space.lists ?? [], id: \.id) { list in
                            NavigationLink {
                                ListView(list: list)
                            } label: {
                                HStack(spacing: 8.0) {
                                    Image(systemName: "list.dash")
                                    Text(list.name)
                                }
                            }

                        }
                    } header: {
                        HStack(spacing: 8.0) {
                            Text(space.name)
                            if space.private! {
                                Image(systemName: "lock.fill")
                            }
                        }
                    }
//                    #if os(macOS)
//                    .collapsible(true)
//                    #endif
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Spaces")
        }
        .task {
            loadAPIKeys()
            if let workspaceList = await getWorkspaces() {
                workspaces = workspaceList.teams
            }
            if workspaces.count > 0 {
                if let spacesList = await getSpaces(teamID: workspaces[0].id) {
                    spaces = spacesList.spaces
                }
            }
            for i in spaces.indices {
                Task {
                    if let foldersList = await getFolders(spaceID: spaces[i].id) {
                        spaces[i].setFolders(foldersList.folders)
                    }
                    if let listsList = await getFolderLessLists(spaceID: spaces[i].id) {
                        spaces[i].setLists(listsList.lists)
                    }
                }
            }
        }
    }
    
    func loadAPIKeys() {
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") {
            for (key, value) in NSDictionary(contentsOfFile: path)! {
                if key as! String == "clickup" {
                    apiKey = value as! String
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
