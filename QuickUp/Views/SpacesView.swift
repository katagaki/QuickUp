//
//  SpacesView.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import SwiftUI

struct SpacesView: View {
    
    @Binding var appState: QuickUpState
    @State var isSelectingWorkspace: Bool = false
    @State var isChangingSettings: Bool = false
    
    @State var workspaces: [CUWorkspace] = []
    @State var workspaceIndex: Int = 0
    @State var spaces: [CUSpace] = []
    @State var filteredFolders: [CUFolder] = []
    @State var searchTerm: String = ""
    @State var loadingLists: [String:Bool] = [:]
    
    var body: some View {
        NavigationView {
            List {
                if searchTerm.count == 0 {
                    ForEach(spaces, id: \.id) { space in
                        Section {
                            ForEach(space.folders ?? [], id: \.id) { folder in
                                FolderNavigationLink(folder: folder)
                            }
                            ForEach(space.lists ?? [], id: \.id) { list in
                                ListNavigationLink(loadingLists: $loadingLists, list: list)
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
            .sheet(isPresented: $isSelectingWorkspace, content: {
                SpaceSelectionView(appState: $appState, workspaces: $workspaces, workspaceIndex: $workspaceIndex)
            })
            .sheet(isPresented: $isChangingSettings, content: {
                SettingsView(appState: $appState)
            })
            #if os(iOS)
            .toolbar() {
                ToolbarItem(placement: .confirmationAction) {
                    if workspaces.count >= 1 {
                        Menu(workspaces[workspaceIndex].name) {
                            ForEach(0..<workspaces.count, id: \.self) { i in
                                Button {
                                    workspaceIndex = i
                                } label: {
                                    Image("IconSpace")
                                    Text(workspaces[i].name)
                                }
                            }
                        }
                    }
                }
            }
            #endif
            .navigationTitle("Spaces")
        }
        .onChange(of: appState) { newValue in
            // TODO: Show workspace selection, settings, etc with state change
            switch newValue {
            case .workspaceSelection:
                isSelectingWorkspace = true
                isChangingSettings = false
            case .settings:
                isChangingSettings = true
                isSelectingWorkspace = false
            default:
                isSelectingWorkspace = false
                isChangingSettings = false
                if apiKey != defaults.string(forKey: "Token.Personal") ?? "" {
                    Task {
                        loadAPIKeys()
                        await loadData()
                    }
                }
            }
        }
        .onChange(of: workspaceIndex, perform: { newValue in
            Task {
                await loadData()
            }
        })
        .task {
            loadAPIKeys()
            await loadData()
        }
    }
    
    func loadData() async {
        var workspaces: [CUWorkspace] = []
        if let workspaceList = await getWorkspaces() {
            workspaces = workspaceList.teams
            self.workspaces = workspaces
            if workspaces.count > 0 {
                if let spacesList = await getSpaces(teamID: workspaces[workspaceIndex].id) {
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
                }
                Task {
                    if let listsList = await getFolderLessLists(spaceID: spaces[i].id) {
                        spaces[i].setLists(listsList.lists)
                    }
                }
            }
        }
    }
    
    func loadAPIKeys() {
        apiKey = defaults.string(forKey: "Token.Personal") ?? ""
    }
}
