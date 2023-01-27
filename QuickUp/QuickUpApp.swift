//
//  QuickUpApp.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import SwiftUI

@main
struct QuickUpApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            SpacesView()
            #else
            MainTabView()
            #endif
        }
        .commands {
            SidebarCommands()
            CommandGroup(replacing: .appSettings) {
                Button("Settings") {
                    // TODO: Implement view for inputting API key
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
