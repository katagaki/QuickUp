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
    @State var filteredFolders: [CUFolder] = []
    @State var searchTerm: String = ""
    
    var body: some View {
        NavigationView {
            List {
                if searchTerm.count == 0 {
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
                                Text(space.name ?? "Untitled Space")
                                if space.private! {
                                    Image(systemName: "lock.fill")
                                }
                            }
                        }
                    }
                } else {
                    ForEach(filteredFolders, id: \.id) { folder in
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
                }
            }
            .listStyle(.sidebar)
            .searchable(text: $searchTerm, placement: .sidebar, prompt: "Search Folders")
            .onChange(of: searchTerm, perform: { newValue in
                filteredFolders.removeAll()
                for space in spaces {
                    filteredFolders.append(contentsOf: space.folders?.filter({ folder in
                        folder.name.lowercased().contains(searchTerm.lowercased())
                    }) ?? [])
                }
                filteredFolders.sort(by: { a, b in
                    a.name.lowercased() < b.name.lowercased()
                })
            })
            .navigationTitle("Spaces")
        }
        .task {
            loadAPIKeys()
            if let workspaceList = await getWorkspaces() {
                workspaces = workspaceList.teams
            }
            if workspaces.count > 0 {
                if let spacesList = await getSpaces(teamID: workspaces[0].id) {
                    spaces = spacesList.spaces.sorted(by: { a, b in
                        (a.name ?? "").lowercased() < (b.name ?? "").lowercased()
                    })
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
