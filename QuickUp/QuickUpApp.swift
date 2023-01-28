//
//  QuickUpApp.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import SwiftUI

@main
struct QuickUpApp: App {
    
    @ObservedObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            SpacesView(appState: $appState.current)
            #else
            MainTabView()
            #endif
        }
        .commands {
            SidebarCommands()
            CommandGroup(replacing: .appSettings) {
                Button("Settings") {
                    appState.current = .settings
                }
                .keyboardShortcut(",", modifiers: .command)
            }
            CommandMenu("Workspace") {
                Button("Switch Workspace...") {
                    appState.current = .workspaceSelection
                }
                .keyboardShortcut("1", modifiers: [.command, .option])
            }
        }
    }
}
